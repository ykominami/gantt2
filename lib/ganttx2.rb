# frozen_string_literal: true

require_relative "ganttx2/version"
require_relative "ganttx2/daterange"
require_relative "ganttx2/daterangelist"
require_relative "ganttx2/ganttdata"
require_relative "ganttx2/itemx"
require_relative "ganttx2/section"
require_relative "ganttx2/sectionlist"
require_relative "ganttx2/spreadsheet"
require_relative "ganttx2/cli"
require_relative "ganttx2/utils"
require_relative "ganttx2/dateorderedsectionlist"

module Ganttx2
  class Error < StandardError; end
  class InvalidStartDateClassError < Error; end
  class InvalidDataYamlError < Error; end
  class InvalidConfigYamlError < Error; end
  # Your code goes here...
  EXIT_CODE = 10
  EXIT_CODE_OF_SUCCESS = 0
end

