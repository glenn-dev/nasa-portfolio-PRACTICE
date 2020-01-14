require 'uri'
require 'net/http'
require 'json'
require_relative 'lib/helpers'

def request(url, api_key)               #Metodo request.
    url = URI(url + api_key)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    JSON.parse(response.read_body)
end

def buid_web_page (respuesta)           #metodo que toma la respuesta del metoso 'request' y construye un documento html.

                                        #Limpiando la data...
    clean_data = respuesta['photos']    #Arreglo que almacena elementos (tipo hash) contenidos dentro del hash principal.
    photo_info = {}                     #Hash que almacena cada elemento dentro del arreglo 'clean_data'.
    photo_src = []                      #Arreglo que almacena las url de las fotos provistas por la key 'img_src' dentro del hash 'photo_info'.
    
    clean_data.each do |i|              #Recorre el contenido para obtener la url de cada foto.
        photo_info = i
        photo_src.push(photo_info['img_src']) #Crea un arreglo con las url de cada foto.
    end
    
    File.open('index.html', 'w') do |f| #Construye el documento html.

        f.puts head                     #Llama a metodo que contiene estructura del header.
    
            f.puts '<h1>Portafolio NASA</h1>
                <ul>'
            photo_src.each do |i|
            f.puts "<li> 
            <img src='#{i}' class='col-sm-5 rounded my-3' alt=''>
            <a href='#{i}' target='_blanc' download='proposed_file_name' type='button' class='btn btn-outline-primary'>Ver en pantalla completa</a>
            </li>"
            f.puts '</ul>'
        end

        f.puts footer                   #Llama a metodo que contiene estructura del footer.
    end
end

#llamado de prueba
buid_web_page(request('https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10&api_key=', 'fmU7e9xWOdVaJsBJVZjWtjOkcm6Sbw9id6e8feLi'))