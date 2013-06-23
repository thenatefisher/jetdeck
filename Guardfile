# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec', :notification=> true,
      :spring => true,
      :binstubs => true do

  watch(%r{^spec/.+_spec.rb$})
  watch(%r{^app/(.+).rb$})                            { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+).rb$})                            { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^spec/factories/(.+).rb$})                 { "spec" }
  watch(%r{^spec/models/(.+).rb$})                    { |m| "spec/models/#{m[1]}.rb" }
  watch(%r{^spec/fixtures/.+.rb$})                    { "spec/fixtures" }
  watch(%r{^spec/requests/(.+).rb$})                   { |m| "spec/requests/#{m[1]}.rb" }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('spec/spec_helper.rb')                        { "spec" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }

  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/requests/#{m[1]}_spec.rb" }

end

