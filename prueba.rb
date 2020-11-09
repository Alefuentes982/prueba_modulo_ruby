
require "uri"
require "net/http"
require 'json'

#####################################################################

def request (url, key)
    pagina = url + "&api_key=" + key

    url2 = URI(pagina)

    https = Net::HTTP.new(url2.host, url2.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url2)

    response = https.request(request)

    JSON.parse(response.read_body)
end
######################################################################

def crea_web(rov)
    pagina_html = '
<!DOCTYPE html>
<html lang="es" dir="ltr">  
    <head> 
        <meta charset="utf-8">
        
        <meta name="author" content="Ale-Fuentes">
        <meta name="description" content="Imagenes tomadas por Rover">
        
        <title>ROVER</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
       
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2" crossorigin="anonymous">
                       
        <script src="https://kit.fontawesome.com/7beacc8ced.js" crossorigin="anonymous"></script>

    </head>
    
    <body class="bg-dark">
        
        <nav class="navbar navbar-expand-md navbar-light bg-success text-white fixed-top px-5">
                  <div class="container">
                  <i class="fas fa-space-shuttle fa-3x "></i>
                  <h1 class="m-auto p-auto">IMAGENES TOMADAS POR ROVER</h1>
                  </div>
        </nav> 
                  <div class="container text-center mt-5 pt-5">
                  <ul class="list-group list-group-horizontal-md min-width rounded-0">'
          
    ln = 0
    rov["photos"].count.times do |i|
        imagen = rov["photos"][i]["img_src"] 
        pagina_html = pagina_html + '<li class="list-group-item"><img class="img-fluid h-100" src="'+ imagen +'" alt="img=' + (i.to_s) + '"></li>'
        ln += 1
        if i < 24
            if ln == 2 || ln == 5
                pagina_html += '
                </ul> 
                <ul class="list-group list-group-horizontal-md min-width rounded-0">'
            end
            if ln == 5
                ln = 0
            end
        end
    end
    
    pagina_html += '     
                </ul>            
        </div>
    </body>

    footer = 
    <footer class="mt-1 mb-1 container-fluid text-white bg-warning">
        
        <div class="container mt-2 py-2">
        <div class="flex-container m-3 p-3 justify-content-center socialmedia">
        <h2 class="my-4 text-white font-weight-bold mr-5 text-center">para mas contenido visita mi git-hub</h2></div>
        <div class="text-center"><a href="https://github.com/Alefuentes982" target="_blank"><i class="fab fa-github fa-5x mx-3 text-white"></i></a></div>
        </div>
    </footer>


</html>'
    
    File.write("./pagina.html", pagina_html)
end

############################################################

def photos_count (rover)
    conteo = {}
        
    rover["photos"].each do |elemento|
        elemento["camera"].each do |k, v|
            if k == "name"
                if conteo.include? v
                    conteo[v] += 1
                else
                    conteo[v] = 1
                end
            end
        end
    end
    conteo
end

url = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&"
key = "DEMO_KEY"
 

nasa_rover = request(url, key)

crea_web(nasa_rover)

print "\n"
print "el conteo de fotos por camara es: #{photos_count(nasa_rover)}"
print "\n"