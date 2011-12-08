# app/models/email_validator.rb

class EmailValidator < ActiveModel::EachValidator
  REGEXP = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  
  def validate_each(record, attribute, value)
    record.errors[attribute] << "#{value} is not a valid email address" unless value =~ REGEXP
  end # method validate_each
end # validator Email
