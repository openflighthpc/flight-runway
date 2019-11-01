#==============================================================================
# Copyright (C) 2019-present Alces Flight Ltd.
#
# This file is part of Flight Runway.
#
# This program and the accompanying materials are made available under
# the terms of the Eclipse Public License 2.0 which is available at
# <https://www.eclipse.org/legal/epl-2.0>, or alternative license
# terms made available by Alces Flight Ltd - please direct inquiries
# about licensing to licensing@alces-flight.com.
#
# Flight Runway is distributed in the hope that it will be useful, but
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR
# IMPLIED INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OR CONDITIONS
# OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A
# PARTICULAR PURPOSE. See the Eclipse Public License 2.0 for more
# details.
#
# You should have received a copy of the Eclipse Public License 2.0
# along with Flight Runway. If not, see:
#
#  https://opensource.org/licenses/EPL-2.0
#
# For more information on <project>, please visit:
# https://github.com/openflighthpc/flight-runway
#==============================================================================
module OpenFlight
  class << self
    ENV_MUTEX = Mutex.new
    FLIGHT_RUBY_ORIG_PREFIX = 'flight_RUBY_orig_'.freeze
    NULL = 'NULL'.freeze
    STANDARD_ENV = ENV.to_hash.tap do |h|
      h.keys.select do |k|
        k.start_with?(FLIGHT_RUBY_ORIG_PREFIX)
      end.each do |k|
        v = h.delete(k)
        k = k[FLIGHT_RUBY_ORIG_PREFIX.length..-1]
        if v == NULL
          h.delete(k)
        else
          h[k] = v
        end
      end
    end

    def with_standard_env
      with_env(standard_env) { yield }
    end

    def standard_env
      STANDARD_ENV.clone
    end

    def with_unbundled_env(&block)
      if Kernel.const_defined?(:Bundler)
        with_standard_env do
          msg = Bundler.respond_to?(:with_unbundled_env) ? :with_unbundled_env : :with_clean_env
          Bundler.__send__(msg) do
            block.call
          end
        end
      else
        with_standard_env do
          block.call
        end
      end
    end

    def set_standard_env
      ENV_MUTEX.synchronize do
        ENV.clear.replace(standard_env)
      end
    end

    private
    def with_env(env)
      ENV_MUTEX.lock
      backup = ENV.to_hash
      ENV.clear.replace(env)
      yield
    ensure
      ENV.clear.replace(backup)
      ENV_MUTEX.unlock
    end
  end
end
