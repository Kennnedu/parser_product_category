#!/usr/bin/env ruby
require 'nokogiri'
require 'open-uri'
require 'xpath'
require 'csv'
require 'pry'
require_relative 'application_base'
require_relative 'parser_products'
require_relative 'product'
require_relative 'multiproduct'

ParserProducts.new(ARGV[0], ARGV[1]).parse
