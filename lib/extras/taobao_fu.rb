# -*- encoding : utf-8 -*-
begin
  require "typhoeus"
rescue LoadError
  puts "The Typhoeus gem is not available.\nIf you ran this command from a git checkout " \
       "of Rails, please make sure Typhoeus is installed. \n "
  exit
end
# require "patron"
require "digest/md5"
require "yaml"
require "uri"

module TaobaoFu

  SANDBOX = 'http://gw.api.tbsandbox.com/router/rest'
  PRODBOX = 'http://gw.api.taobao.com/router/rest'
  USER_AGENT = 'why404-taobao_fu/1.0.0.beta5'
  REQUEST_TIMEOUT = 10
  API_VERSION = 2.0
  SIGN_ALGORITHM = 'md5'
  OUTPUT_FORMAT = 'json'

  class << self
    def load(config_file)
      @all_settings = YAML.load_file(config_file)
      # @settings = @all_settings[[Rails.env,"key2"].sample]
      @settings = @all_settings[Rails.env]
      apply_settings
    end
    def change_settings
      #@settings = @all_settings[[Rails.env,"back"].sample]
    end
    def use_front_key
      #@settings = @all_settings["front"]
    end

    def apply_settings
      ENV['TAOBAO_API_KEY']    = @settings['app_key'].to_s
      ENV['TAOBAO_SECRET_KEY'] = @settings['secret_key']
      ENV['TAOBAOKE_NICK']      = @settings['taobaoke_nick']
      @base_url                = @settings['is_sandbox'] ? SANDBOX : PRODBOX

      initialize_session if @settings['use_curl']
    end

    def initialize_session
      @sess = Patron::Session.new
      @sess.base_url = @base_url
      @sess.headers['User-Agent'] = USER_AGENT
      @sess.timeout = REQUEST_TIMEOUT
    end

    def switch_to(sandbox_or_prodbox)
      @base_url = sandbox_or_prodbox
      @sess.base_url = @base_url if @sess
    end

    def get(options = {})

      if @sess
        @response = @sess.get(generate_query_string(sorted_params(options)))
      else
        params = generate_query_vars(sorted_params(options))
        @response = Typhoeus::Request.get(@base_url, :params=>params)
      end
      parse_result @response
    end

    def sorted_params(options)
      {
        :app_key     => @settings['app_key'],
        :format      => OUTPUT_FORMAT,
        :v           => API_VERSION,
        :sign_method => SIGN_ALGORITHM,
        :timestamp   => Time.now.strftime("%Y-%m-%d %H:%M:%S")
      }.merge!(options)
    end

    def generate_query_vars(params)
      str = params.sort_by { |k,v| k.to_s }.flatten.join
      params[:sign] = generate_sign(str)
      params
    end

    def generate_query_string(params)
      params_array = params.sort_by { |k,v| k.to_s }
      sign_token = generate_sign(params_array.flatten.join)
      total_param = params_array.map { |key, value| key.to_s+"="+value.to_s } + ["sign=#{sign_token}"]
      URI.escape(total_param.join("&"))
    end

    def generate_sign(param_string)
      Digest::MD5.hexdigest(@settings['secret_key'] + param_string + @settings['secret_key']).upcase
    end
    def generate_xtao_sign
      timestamp = "#{Time.now.to_i}000"
      param_string = {"app_key"=>@settings['app_key'],"timestamp"=>timestamp}.flatten.join
      param_string = sprintf("%1$s%2$s%1$s",@settings['secret_key'],param_string)
      {:timestamp=>timestamp,:sign=>Digest::HMAC.hexdigest(param_string,@settings['secret_key'],Digest::MD5)}
    end

    def parse_result(res)
      JSON.parse(res.body)
    end
    def parse_xml str
      Hash.from_xml(str)
    end
    def fetch(options = {})
      r = 4
      while 1==1
        change_settings
        params = generate_query_vars(sorted_params(options))
        @response = Typhoeus::Request.get(@base_url, :params=>params)
        if @response.success?
          rs = options[:format].present? ? parse_xml(@response.body) : JSON.parse(@response.body)
          if is_error? rs
            if error_code == 7
              r-=1
              return false if r == 0
              sleep 70
            else
              Rails.logger.info [rs,options]
              return rs
            end
          else
            return rs[res_name(options[:method])]
          end
        else
          r-=1
          return false if r == 0
          sleep 30 
        end
      end
    end
    def res_name str
      str.sub(/^taobao\./,'').gsub(/\./,'_')+"_response"
    end
    def is_error? rs
      @error = {}
      if rs.is_a?(Hash) and rs.has_key? "error_response"
        @error = rs["error_response"]
      end
      @error.present?
    end
    def error_code
      @error["code"].to_i
    end
  end
  class Api
    def is_error? rs
      if rs.is_a?(Hash) and rs.has_key? "error_response"
        @error = rs["error_response"]
      end
      @error.present?
    end
    def parse rs
      if is_error? rs
        Rails.logger.info rs
        if error_code == 7
          sleep 60
        end
      end
    end
    def get_items word,options={}
      rs = get_items_by_keyword(word,options)
      Rails.logger.info rs and return if is_error? rs
      items = rs["items_get_response"]
      return [] if items["items"].nil?
      nids = items["items"]["item"].collect{|i| i["num_iid"]}.join(",")
      rs = taoke_convert_items(nids)
      Rails.logger.info rs and return if is_error? rs
      nitems = rs["taobaoke_items_convert_response"]
      return [] if nitems["taobaoke_items"].nil?
      nitems["total_results"] = items["total_results"]
      nitems
    end
    def get_paged_items word,options={}
      options = {:page_size=>60}.merge options
      rs = get_items_by_keyword(word,options)
      Rails.logger.info rs and return if is_error? rs
      items = rs["items_get_response"]
      return [] if items["items"].nil?
      nids = items["items"]["item"].collect{|i| i["num_iid"]}

      nitems = []
      i=-1
      # pp nids.size
      limit = 20
      while i+=1
        arr = nids.slice(i*limit,limit)
        break unless arr.present?
        nitems += get_items_data arr.join(",")
        # pp nitems.size
      end
      {"taobaoke_items"=>{"taobaoke_item"=>nitems},"total_results"=>items["total_results"]}
      #nitems["total_results"] = items["total_results"]
    end
    def get_items_data nids
      rs = taoke_convert_items(nids)
      return [] if is_error? rs
      rs["taobaoke_items_convert_response"]["taobaoke_items"]["taobaoke_item"] rescue false
    end
    def topats_itemcats_get cids=0,options={}
      args = {
        :cids => 0,
        :output_format => 'json',
        :type => 1
      }
      args.merge! options
      args[:method] = 'taobao.topats.itemcats.get'
      TaobaoFu.get(args)
    end

    def get_items_by_keyword word,options={}
      args =  {
        :q    => word,
        :order_by => 'popularity',
        :page_no => 1,
        :page_size => 40,
        :fields => 'num_iid'
      }
      args.merge! options
      args[:method] = 'taobao.items.get'
      TaobaoFu.get(args)
    end
    def taoke_convert_items nids
      args =  {
        :num_iids => nids,
        :nick => 'usedcar',
        :oter_code => nil,
        :fields => 'num_iid,title,nick,pic_url,price,click_url,commission,commission_rate,commission_num,commission_volume,shop_click_url,seller_credit_score,item_location,volume'
      }
      args[:method] = 'taobao.taobaoke.items.convert'
      items = TaobaoFu.get(args)
      items
    end
    def taoke_items_detail_get nids,options={}
      args =  {
        :num_iids => nids,
        :fields => 'commission,click_url,shop_click_url,seller_credit_score,num_iid,title,nick,detail_url,desc,created,cid,pic_url,delist_time,location,price,express_fee,product_id,item_imgs,volume,sell_promise'
      }
      args.merge! options
      args[:method] = 'taobao.taobaoke.items.detail.get'
      TaobaoFu.fetch(args)
    end
    def taoke_get_items_by_cid cid,options={}
      args =  {
        :cid    => cid,
        :nick => 'usedcar',
        :sort => 'commissionVolume_desc',
        :page_no => 1,
        :fields => 'num_iid,title,nick,pic_url,price,click_url,commission,commission_rate,commission_num,commission_volume,shop_click_url,seller_credit_score,item_location,volume'
      }
      args.merge! options
      args[:method] = 'taobao.taobaoke.items.get'
      TaobaoFu.fetch(args)
    end

    def taoke_get_items_by_keyword word,options={}
      args =  {
        :keyword    => word,
        :nick => 'usedcar',
        :sort => 'commissionVolume_desc',
        :page_no => 1,
        :fields => 'num_iid,title,nick,pic_url,price,click_url,commission,commission_rate,commission_num,commission_volume,shop_click_url,seller_credit_score,item_location,volume'
      }
      args.merge! options
      args[:method] = 'taobao.taobaoke.items.get'
      TaobaoFu.fetch(args)
    end
    def shop_get nick
      args =  {
        :format => "xml",
        :nick => nick,
        :fields => 'sid,cid,title,desc,bulletin,pic_path,created,modified,shop_score'
      }
      args[:method] = 'taobao.shop.get'
      TaobaoFu.fetch args
    end
    def taobaoke_shops_get cid,options={}
      args =  {
        :cid => cid, 
        :page_no => 1,
        :fields => 'shop_id,seller_nick,shop_title,user_id,click_url,commission_rate,seller_credit,shop_type,total_auction,auction_count',
        :sort_field => 'total_auction',
        :sort_type => 'desc',
        :page_size => 100,
        :outer_code => 'sdmec'

      }
      args.merge! options
      args.delete :cid if cid.blank?
      args[:method] = 'taobao.taobaoke.shops.get'
      TaobaoFu.fetch(args)
    end
    def taobaoke_shops_convert nicks
      args =  {
        :seller_nicks => nicks.is_a?(Array) ? nicks.join(',') : nicks,
        :fields => 'user_id,click_url,commission_rate,seller_credit,shop_type,total_auction,auction_count'
      }
      args[:method] = 'taobao.taobaoke.shops.convert'
      TaobaoFu.fetch(args)
    end
    def taobaoke_items_relate_get options={}
      args = {
        :relate_type=>4,
        #:seller_id=>
        :fields=>'num_iid,title,nick,pic_url,price,click_url,commission,ommission_rate,commission_num,commission_volume,shop_click_url,seller_credit_score,item_location,volume'
      }
      args.merge! options
      args[:method] = 'taobao.taobaoke.items.relate.get'
      TaobaoFu.fetch(args)
    end
    def get_shopcats
      TaobaoFu.fetch :method=>'taobao.shopcats.list.get',:fields=>'cid,name'
    end

    def taoke_get_report options={}
      args =  {
        :date => Date.yesterday.strftime('%Y%m%d'),
        :page_no => 1,
        :fields => 'trade_id,pay_time,pay_price,num_iid,outer_code,commission_rate,commission,seller_nick,pay_time,app_key'
      }
      #pp args
      args.merge! options
      args[:method] = 'taobao.taobaoke.report.get'
      TaobaoFu.fetch args
    end
    def get_products_by_keyword word,options={}
      args =  {
        :q    => word,
        :status => 3,
        :page_size => 40,
        :page_no => 1,
        :fields => 'product_id,cid,props,name,pic_url'
      }
      args.merge! options
      args[:method] = 'taobao.products.search'
      items = TaobaoFu.get(args)
      items
    end
    def itemcats_get parent_cid=0,cids=nil
      args =  {
        :parent_cid    => parent_cid,
        # :cids => cids,
        :fields => 'cid,parent_cid,name,is_parent,sort_order,status'
      }
      args[:method] = 'taobao.itemcats.get'
      items = TaobaoFu.fetch(args)
      items.present? ? items["item_cats"]["item_cat"] : nil
    end
    def tmall_temai_subcats_search cat=50100982
      rs = TaobaoFu.fetch :cat=>cat,:method=>'tmall.temai.subcats.search'
      rs["cat_list"]["tmall_tm_cat"]
    end
    def tmall_temai_cats
      roots = tmall_temai_subcats_search
      roots.collect do |v|
        v["children"] = tmall_temai_subcats_search(v["sub_cat_id"])
        v
      end
    end
    def tmall_temai_items_search options={}
      return nil if options[:cat].nil?
      TaobaoFu.fetch options.merge(:method=>'tmall.temai.items.search')
    end
  end

end
TaobaoFu.load "#{Rails.root}/config/taobao.yml" 
