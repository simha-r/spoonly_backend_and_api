module HealthyLunchUtils
  def self.log_error message, e = nil
    Rails.logger.error "ERROR - #{message} #{e ? "Exception - #{e.message}, Backtrace - #{e.backtrace.to_s}" : nil}"
  end

  def self.log_info message
    Rails.logger.info message
  end
end