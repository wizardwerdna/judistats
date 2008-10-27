module DashboardsHelper
  def as_percentage(numerator, denominator, format = "%3.0f%%", error_string = "***")
    numerator = 0 if numerator.blank?
    denominator = 0 if denominator.blank?
    numerator = numerator.to_i
    denominator = denominator.to_i
    return error_string if denominator.zero?
    format % ((100.0 * numerator) / denominator)
  end
  
  def as_ratio(numerator, denominator, format = "%3.1f", error_string = "***", max_threshold=10, max_string = "10+")
    numerator = 0 if numerator.blank?
    denominator = 0 if denominator.blank?
    numerator = numerator.to_i
    denominator = denominator.to_i
    return error_string if denominator.zero?
    return max_string if (numerator/denominator) >= max_threshold
    format % ((1.0 * numerator) / denominator)
  end
end
