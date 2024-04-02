def model_class
  self.class.name.split(':')[-1].sub('Controller', '').singularize.constantize
end

def model_representer
  model_name = model_class.name
  "#{model_name}sRepresenter".constantize
end

def permitted_params
  raise NotImplementedError, 'Classes that uses DefaultHandlers must define a permitted_params method'
end

def model_params
  raise NotImplementedError, 'Classes that uses DefaultHandlers must define a model_params method'
end
