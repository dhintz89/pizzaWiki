require 'sinatra' # includes gem to process web pages
require 'sinatra/activerecord'
set :bind, '0.0.0.0' # sets default url address to localhost

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'pizzaWiki.db'
)

class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true
end

$myinfo = "Pizza Team"
@info = ""


def readFile(filename)# crates a method to read a file and puts its info into a global varible
	info = ""
	file = File.open(filename)
	file.each do |line|
		info = info + line
	end
	file.close
	$myinfo = info
end

get '/' do  #binds the route url to the ruby route
	info = "Welcome!"
	len = info.length #creates variable len and assigns it the integer value of the number of characters in the info string
	len1 = len
	#readFile("wiki.txt") #invokes a method to read the info from a text file (Commented whole line out until wiki.txt exists)
	@info = info + " " + $myinfo #puts the text file info into an object
	len = @info.length
	len2 = len - 1
	len3 = len2 - len1
	@words = len3.to_s #counts the number of words and puts it in an object
	erb :home #executetes the external view for the homepage
end

get '/about' do #executetes the external view for the about page
	erb :about
end

get '/create' do #executetes the external view for the create page
	erb :create
end

get'/edit' do #executetes the external view for the homepage
	info = ""
	file = File.open("wiki.txt")
	file.each do |line|
		info = info + line #extracts all the wiki texs and puts it into a varible
	end
	file.close
	@info = info #puts the varible into an object so the user can see what he is editing
	erb:edit
end

put '/edit' do #sub program to write user created wiki info to file
	info = "#{params[:message]}" #WTF COME BACK
	@into = info
	file = File.open("wiki.txt", "w")# opens the file for writing
	file.puts @info #commits the info to the file
	file.close
	redirect '/'#the redirect to the hompage signials to the user that their queery has been recived.
end


# get '/noaccount' do
    # erb :noaccount
# end

# get '/denied' do
    # erb :denied
# end

# get '/admincontrols' do
     # # protected!
    # @list2 = User.all.sort_by { |u| [u.id] }
    # erb :admincontrols
# end

get '/login' do
    erb :login
end

post '/login' do
    $credentials = [params[:username],params[:password]]
    @Users = User.where(:username => $credentials[0]).to_a.first
    if @Users
        if @Users.password == $credentials[1]
            redirect '/'
        else
            $credentials = ['','']
            redirect '/wrongaccount'
        end
    else
        $credentials = ['','']
        redirect '/wrongaccount'
    end
end

get '/wrongaccount' do
    erb :wrongaccount
end

get '/createaccount' do
    erb :createaccount
end

post '/createaccount' do  n = User.new
     n.username = params[:username]
     n.password = params[:password]
     if n.username == "Admin" and n.password == "Password"
	  	n.edit = true
	 end
     n.save
    redirect "/"
end

get '/logout' do
    $credentials = ['','']
    redirect '/'
end


# get '/notfound' do
    # erb :notfound
# end

# put '/user/:user' do
    # n = User.where(:username => params[:uzer]).to_a.first
    # n.edit = params[:edit] ? 1 : 0
    # n.save
    # redirect '/'
# end

# get '/user/delete/:user' do
    # # protected!
    # n = User.where(:username => params[:uzer]).to_a.first
    # if n.username == "Admin"
	  	# erb :denied
    # else
	  	# n.destroy
	  	# @list2 = User.all.sort_by { |u| [u.id] }
        		# erb :admincontrols
    # end
# end


not_found do # if a user try to load a page that dose not exist
    status 404
    redirect '/notfound'
end
