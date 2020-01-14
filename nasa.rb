require 'uri'
require 'net/http'
require 'json'
require_relative 'lib/helpers'

#Metodo request.
def request(url, api_key)
    url = URI(url + '&api_key=' + api_key)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    JSON.parse(response.read_body)
end

#Metodo que toma la respuesta del metodo request, 'limpia' la data y construye un documento html.
def buid_web_page (respuesta)

    clean_data = respuesta['photos']    #Arreglo que almacena elementos (tipo hash) contenidos dentro del hash principal.
    photo_info = {}                     #Hash que almacena cada elemento dentro del arreglo 'clean_data'.
    photo_src = []                      #Arreglo que almacena las url de las fotos provistas por la key 'img_src' dentro del hash 'photo_info'.
    info_camera = []

    clean_data.each do |i|              #Recorre el contenido para obtener la url de cada foto.
        photo_info = i
        photo_src.push(photo_info['img_src']) #Crea un arreglo con las url de cada foto.
        info_camera.push(photo_info['camera']) #Crea un arreglo con los elementos del hash 'camera'.
    end

    acum = Hash.new(0)                  #acumulador de elementos del hash 'camera'.
    info_camera.each do |v|
        acum[v] += 1
    end
    acum.each do |k, v|
        puts "Hay #{v} fotos de la camara #{k['name']}"
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
buid_web_page(request('https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10', 'fmU7e9xWOdVaJsBJVZjWtjOkcm6Sbw9id6e8feLi'))