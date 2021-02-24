class TestsController < Simpler::Controller

  def index
    render plain: 'Some-text', status: 404
  end

  def create

  end

end
