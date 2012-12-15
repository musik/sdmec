require 'redis/model'
  def keep_time n=1,&block
    s = Time.now
    yield
    e = Time.now
    t = e - s
    sleep n - t if n > t
  end
