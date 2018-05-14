#!/usr/bin/env ruby
require 'byebug'
require 'nokogiri'
require 'open-uri'
require 'csv'
require_relative 'parser_helper'
require_relative 'category_extractor'
require_relative 'product_extractor'
require_relative 'multiproduct_extractor'

CategoryExtractor.call(ARGV[0], ARGV[1])
