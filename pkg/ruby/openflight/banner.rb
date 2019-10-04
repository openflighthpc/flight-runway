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
require 'erb'

module OpenFlight
  module Banner
    class << self
      def sysroot
        File.join(
          File.dirname(__FILE__),
          'resources'
        )
      end

      def root
        File.join(
          ENV.fetch('flight_ROOT','/opt/flight'),
          'etc',
          'banner'
        )
      end

      def banner_template_file
        f = File.join(root, 'banner.erb')
        File.exist?(f) ? f : File.join(sysroot, 'banner.erb')
      end

      def valid_banner?(banner)
        File.directory?(root) &&
          File.exist?(File.join(root, "#{banner}.yml"))
      end

      def template
        ERB.new(
          File.read(banner_template_file),
          nil,
          '-'
        )
      end

      def render(opts, banner = nil)
        render_env = Module.new
        render_env.instance_variable_set(:@opts, opts)
        if valid_banner?(banner)
          render_env.instance_variable_set(:@root, root)
          render_env.instance_variable_set(:@banner, banner)
        else
          render_env.instance_variable_set(:@root, sysroot)
        end
        ctx = render_env.instance_eval { binding }
        template.result(ctx)
      end
    end
  end
end
