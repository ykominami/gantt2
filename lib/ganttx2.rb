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
  class Ganttx2Error < StandardError; end
  class InvalidStartDateClassError < Ganttx2Error; end
  class InvalidDataYamlError < Ganttx2Error; end
  class InvalidConfigYamlError < Ganttx2Error; end
  class InvalidClassError < Ganttx2Error; end
  class NilError < Ganttx2Error; end
  class NotNilError < Ganttx2Error; end
  class InvalidStartDateError < Ganttx2Error; end
=begin
  class Error < Ganttx2Error; end
  class Error < Ganttx2Error; end
  class Error < Ganttx2Error; end
  class Error < Ganttx2Error; end
=end
  # Your code goes here...
  EXIT_CODE = 10
  EXIT_CODE_OF_SUCCESS = 0
end

