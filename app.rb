require("sinatra")
require("sinatra/reloader")
also_reload("lib/**/*.rb")
require("./lib/task")
require("./lib/list")
require("pg")
require('pry')

DB = PG.connect({:dbname => "to_do_test"})

get('/') do
  @lists = List.all
  erb(:index)
end

post('/lists') do
  name = params.fetch('name')
  new_list = List.new({:name => name, :id => nil})
  new_list.save
  @lists = List.all
  erb(:index)
end

get('/lists') do
  @lists = List.all()
  erb(:lists)
end

get('/lists/:id') do
  @list = List.find(params.fetch('id').to_i)
  erb(:list)
end

post('/tasks') do
  description = params.fetch('description')
  list_id = params.fetch('list_id').to_i
  due_date = params.fetch('due_date')
  task = Task.new({:description => description, :list_id => list_id, :due_date => due_date})
  task.save
  @list = List.find(list_id)
  erb(:list)
end

get('/lists/:id/edit') do
  @list = List.find(params.fetch('id').to_i)
  erb(:list_edit)
end

patch('/lists/:id') do
  name = params.fetch('name')
  @list = List.find(params.fetch('id').to_i)
  @list.update({:name => name})
  erb(:list)
end
