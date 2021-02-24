class TestsController < Simpler::Controller

  def index
    response_status(404)
    render plain: 'Some-text'
  end

  def create

  end

end
