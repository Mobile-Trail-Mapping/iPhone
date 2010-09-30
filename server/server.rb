require 'rubygems'
require 'sinatra'
require 'config/init'
require 'digest/sha1'

configure do
  API_KEY = 5500
end

get '/' do
  "Welcome to mobile trail mapping application"
end

#User Routes
post '/:api_key/user/add' do
  return 'Invalid API Key' if params[:api_key].to_i != API_KEY

  user = User.new(:email => params[:email], :pwhash => params[:pwhash]).save
  return "Added user #{user.email}"
end

#Point Routes
get '/:api_key/point/get' do
  return 'Invalid API Key' if params[:api_key].to_i != API_KEY

  'test point'
end

post '/:api_key/point/add' do
  return 'Invalid API Key' if params[:api_key].to_i != API_KEY
  return 'Invalid username or password' if password_matches_user?(params[:user], params[:pwhash])

  point = Point.create do |p|
    p.lat = params[:lat]
    p.long = params[:long]
    p.desc = params[:desc]
  end

  params[:connections].split(',').each { |p| point.add_point(:id => p.to_i)}
  point.catagory = addCatagory(params[:catagory])
  point.trail = addTrail(params[:trail])
  point.save

  "added point #{point.lat}, #{point.long}"
end
