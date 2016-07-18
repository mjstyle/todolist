class Time

  def search_with_seconds
    self.strftime('%Y-%m-%d %H:%M:%S')
  end

  def self.now_local z_name = 'Eastern Time (US & Canada)'
    begin
      self.now.in_time_zone(z_name)
    rescue
      self.now
    end
  end

  def get_term
    case self.month.to_i
      when *[12,1,2]  then 'Winter'
      when *[3,4,5]   then 'Spring'
      when *[6,7,8]   then 'Summer'
      when *[9,10,11] then 'Fall'
    end
  end

  def beginning_of_the_month
    self.strftime('%Y-%m-01 00:00:00')
  end

  def search
    self.strftime('%Y-%m-%d %H:%M')
  end

  def civil
    self.strftime('%d %b %Y at %I:%M %P')
  end

  def time_only
    self.strftime('%H:%m')
  end

  def search_date
    self.strftime('%Y-%m-%d')
  end

  def slash_date
    self.strftime('%d/%m/%Y')
  end

  def qa_due_date
    self.strftime('%Y-%b-%d')
  end

  def civil_date
    self.strftime('%d %b %Y')
  end

  def civil_time
    self.strftime('%I:%M %P')
  end

  def with_time_zone
    self.strftime('%Y-%m-%dT%H:%M:%S%z')
  end

  def simple_date
    self.strftime('%b %e, %Y')
  end

  def to_ms
    self.to_i*1000
  end

end