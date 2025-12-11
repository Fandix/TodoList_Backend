# frozen_string_literal: true

class ApplicationService
  Result = Struct.new(:success?, :data, :errors, keyword_init: true) do
    def failure?
      !success?
    end
  end

  def self.call(*args, **kwargs)
    new(*args, **kwargs).call
  end

  private

  def success(data = nil)
    Result.new(success?: true, data: data, errors: [])
  end

  def failure(errors)
    Result.new(success?: false, data: nil, errors: Array(errors))
  end
end
