#!/usr/bin/env ruby

require 'pry'
require_relative '../environment'

puts 'Welcome to console mode!'
# rubocop:disable Lint/Debugger
binding.pry(quiet: true)
# rubocop:enable Lint/Debugger
