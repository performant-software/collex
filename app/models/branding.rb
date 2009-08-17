##########################################################################
# Copyright 2007 Applied Research in Patacriticism and the University of Virginia
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##########################################################################

class Branding
	# This contains the functional differences between Collex and the specific implementation of it.
	# In this case, this is the NINES specific stuff
  def self.version
    return "1.5.7"
  end

	def self.yui_path(is_debug)
		if is_debug
			return "/javascripts/yui_2_7_0"
		else
			return '2.7.0'
		end
	end
end