class DefaultRepresenter
  def initialize(objects)
    @objects = objects
  end

  def as_json
    if @objects.respond_to?(:map)
      @objects.map do |object|
        represent_object(object)
      end
    else
      represent_object(@objects)
    end
  end

  private

  def represent_object(object)
    raise NotImplementedError, 'Subclasses must implement represent_object'
  end

  attr_reader :objects
end
