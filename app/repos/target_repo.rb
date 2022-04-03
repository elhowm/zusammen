class TargetRepo < ApplicationRepo
  FILE_PATH = "#{::Ctrl::App::ROOT}/public/targets.json".freeze

  attr_reader :targets

  def initialize
    load
  end

  def add(target)
    return logger.warn('ALREADY_ADDED') if targets.include?(target)

    targets.push(target)
  end

  def remove(target)
    targets.reject! { |item| item == target }
  end

  def flush
    @targets = []
  end

  def reload!
    load
  end

  def save!
    write_file(targets)
  end

  private

  def load
    @targets = read_file.map { |target| Target.new(target) }
  end

  def write_file(new_list)
    Oj.to_file(FILE_PATH, { 'targets' => new_list.map(&:as_json) })
    true
  end

  def read_file
    Oj.load_file(FILE_PATH)['targets']
  end
end
