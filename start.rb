#!/usr/bin/env ruby
require 'nokogiri'
require 'open-uri'
require 'xpath'
require 'csv'
require_relative 'application_base'
require_relative 'application'
require_relative 'product'
require_relative 'extraction_products'

Application.new(ARGV[0], ARGV[1]).start
