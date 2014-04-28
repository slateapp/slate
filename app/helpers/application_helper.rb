module ApplicationHelper
  def flash_class(type)
    {
      notice: "alert-info",
      success: "alert-success",
      error: "alert-danger",
      alert: "alert-warning"
    }[type.to_sym]
  end
end
