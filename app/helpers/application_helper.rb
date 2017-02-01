module ApplicationHelper
  def error_class(type)
    type=="notice" ? 'success' : 'danger'
  end
end
