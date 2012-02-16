class DoesNotMatchFeatureValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    features = record.parent.nil? ? CategoryFeature.top_level : record.parent.category_features(true)
    features.each do |feature|
      if feature.slug == value
        message = "is already taken by an #{feature.feature_type.classify}"
        record.errors[attribute] << (options[:message] || message)
      end # if
    end # each
  end # method validate_each
end # validator DoesNotMatchFeatureValidator
