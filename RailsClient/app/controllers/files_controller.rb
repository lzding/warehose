class FilesController<ApplicationController
  skip_before_filter :configure_permitted_parameters

  def download
    path=File.join('uploadfiles', params[:folder], params[:file])
    send_file path, :filename => params[:file]
  end
end