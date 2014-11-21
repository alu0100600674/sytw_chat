require 'rubygems'
#require 'rspec'
require 'test/unit'
require 'minitest/autorun'
require 'rack/test'
require 'selenium-webdriver'
require 'coveralls'
Coveralls.wear!

require_relative '../chat.rb'

ENV['RACK_ENV'] = 'test'

include Rack::Test::Methods

def app
  Sinatra::Application
end

describe "Contenido de la web" do

  before :all do
    @browser = Selenium::WebDriver.for :firefox
    @web_local = 'http://localhost:4567/'
    @browser.get(@web_local)
	  @browser.manage.timeouts.implicit_wait = 5
  end

  after :all do
    @browser.quit
  end

	it "Carga de la web" do
		get '/'
		assert last_response.ok?
    assert_equal(@web_local, @browser.current_url)
	end

	it "Titulo de la web" do
		get '/'
		assert last_response.body.include?("<title>miniChat</title>")
	end

	it "Mostrando imagen de la web" do
		get '/'
		assert last_response.body.include?("images/logo.png")
	end

	it "Campo para la inserción de un usuario" do
		get '/'
		assert last_response.body.include?("Introduce un nombre")
	end

  it "Botón para entrar en el chat" do
    get '/'
    assert last_response.body.include?("Entrar")
  end

  it "Elementos de la web" do
    @browser.find_element(:id, "cabecera")
    @browser.find_element(:id, "ventana")
    @browser.find_element(:id, "formulario")
    @browser.find_element(:id, "pie")
  end

end
