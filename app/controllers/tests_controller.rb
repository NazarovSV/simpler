class TestsController < Simpler::Controller

  def index
    #add_header_to_response(name: 'Content-Type', value: 'text/html')
    #response_status(404)
  end

  def create; end

  def show
    params[:id]
  end

end
