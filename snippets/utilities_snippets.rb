require 'ruble'

with_defaults :scope => 'source.js' do
  snippet 'Concole Log' do |snip|
    snip.trigger = 'log'
    snip.expansion = 'console.log(${1:object});'
  end
end