#
# Cookbook Name:: chef-guard
# File:: cg_foodcritic_tests
#
# Copyright 2014, Sander van Harmelen
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
#

def dependency_versions(ast)
  raise_unless_xpath!(ast)

  # String literals.
  #
  #     depends 'foo'
  depends = ast.xpath(%q{//command[ident/@value='depends']})

  # Loop through all literal depends and make a hash with names and versions
  deps = Hash.new
  depends.each do |dep|
    name = dep.xpath(%q{descendant::args_add/descendant::tstring_content[1]})
    version = dep.xpath(%q{descendant::args_add/descendant::tstring_content[2]})
    deps[name] = version unless name.to_s == ''
  end

  # Quoted word arrays are also common.
  #
  #     %w{foo bar baz}.each do |cbk|
  #       depends cbk
  #     end
  depends = word_list_values(ast, "//command[ident/@value='depends']")

  # Loop through all word array depends and add them to the 'deps' hash
  depends.each do |dep|
    name = dep
    deps[name] = ''
  end

  # Return the generated 'deps' hash
  deps
end


rule 'CG001', 'Ensure all cookbook dependencies depend on a specific version' do
  tags %w(correctness metadata)
  metadata do |ast|
    matches = []
    # Get and loop through the hash with dependencies
    # and check if they depend on a specific version
    dependency_versions(ast).each do |name,version|
      unless version.to_s != '' && /^(?:= )?\d+\.\d+\.\d+$/ === version.xpath(%q{@value}).to_s
        matches << name
      end
    end
    matches
  end
end
