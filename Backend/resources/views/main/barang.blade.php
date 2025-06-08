<!DOCTYPE html>
<html lang="en">
   <head>
      <meta charset="utf-8">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <!-- mobile metas -->
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <meta name="viewport" content="initial-scale=1, maximum-scale=1">
      <!-- site metas -->
      <title>Produk</title>
      <meta name="keywords" content="">
      <meta name="description" content="">
      <meta name="author" content="">
      <link rel="stylesheet" type="text/css" href="{{ asset('assets/css/form.css') }}">
      <!-- owl carousel style -->
      <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.0.0-beta.2.4/assets/owl.carousel.min.css" />
      <!-- bootstrap css -->
      <link rel="stylesheet" type="text/css" href="{{ asset('assets/css/bootstrap.min.css') }}">
      <!-- style css -->
      <link rel="stylesheet" type="text/css" href="{{ asset('assets/css/style.css') }}">
      <!-- Responsive-->
      <link rel="stylesheet" href="{{ asset('assets/css/responsive.css') }}">
      <!-- fevicon -->
      <link rel="icon" href="{{ asset('assets/images/fevicon.png') }}" type="image/gif" />
      <!-- Scrollbar Custom CSS -->
      <link rel="stylesheet" href="{{ asset('assets/css/jquery.mCustomScrollbar.min.css') }}">
      <!-- Tweaks for older IEs-->
      <link rel="stylesheet" href="https://netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css">
      <!-- owl stylesheets --> 
      <link rel="stylesheet" href="{{ asset('assets/css/owl.carousel.min.css') }}">
      <link rel="stylesheet" href="{{ asset('assets/css/owl.theme.default.min.css') }}">
      <link rel="stylesheet" href="{{ asset('assets/') }}https://cdnjs.cloudflare.com/ajax/libs/fancybox/2.1.5/jquery.fancybox.min.css" media="screen">
   </head>
   <body>
      <!--header section start -->
      <div class="header_section">
         <div class="container">
            <nav class="navbar navbar-dark bg-dark">
               <a class="logo" href="index.html"><h1 style="color: white;">Komptech</h1></a>
               <div class="search_section">
                  <ul><li><a href="/logout">Logout</a></li>
                    <li><a href="/beli"><img src="{{ asset('assets/images/shopping-bag.png') }}"></a></li>
                  </ul>
               </div>
               <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarsExample01" aria-controls="navbarsExample01" aria-expanded="false" aria-label="Toggle navigation">
               <span class="navbar-toggler-icon"></span>
               </button>
               <div class="collapse navbar-collapse" id="navbarsExample01">
                  <ul class="navbar-nav mr-auto">
                     <li class="nav-item active">
                        <a class="nav-link" href="/index">Home</a>
                     </li>
                     <li class="nav-item">
                        <a class="nav-link" href="/barang">Products</a>
                     </li>
                     <li class="nav-item">
                        <a class="nav-link" href="#">Anggota</a>
                     </li>
                     <li class="nav-item">
                        <a class="nav-link" href="/beli">Keranjang</a>
                     </li>
                     <li class="nav-item">
                        <a class="nav-link" href="/logout">Logout</a>
                     </li>
                  </ul>
               </div>
            </nav>
         </div>
      </div>
      <!--header section end -->
      <!-- product section start -->
      <div class="row">
         <div class="col-md-12">
            <div class="container">
               <br>
               <center><h1 class="mt-2 mb-2">Daftar Produk</h1></center>
               <form action="/barang" method="get">
                @csrf
               <a href="/barang/tambah" class="btn btn-success mb-3">Tambah Produk</a>
               <input type="text" name="cari" value="{{ Request::get('cari') }}" class="btn col-md-4 mb-3" placeholder="Seacrh" style="background-color: rgb(200, 208, 209); color: black;" > <input type="submit" value="Cari" class="btn btn-success mb-3">
               <div class="row  row-cols-1 row-cols-md-5 g-4">
                    @foreach ($tampil as $barang)
                     <div data-aos="fade-up" data-aos-anchor-placement="top-center">
                        <div class="col mt-4 mb-4" style="height: 100%;">
                        <div class="card" style="width: 15rem;">
                        <img class="card-img-top" src="{{asset('images/'.$barang->gambar)}}" alt="Card image cap">
                        <div class="card-body">
                           <h5 class="card-title">{{ $barang->nama_barang }}</h5>
                        </div>
                        <ul class="list-group list-group-flush">
                           <li class="list-group-item">Rp {{ $barang->harga }}</li>
                           <li class="list-group-item">Stok: {{ $barang->stok }}</li>
                        </ul>
                        <div class="card-body">
                           <a href="/beli/tambah/{{ $barang->id }}" class="btn btn-success">Beli</a>
                           <a href="/barang/edit/{{ $barang->id }}" class="btn btn-warning">Edit</a>
                            <form action="/barang/hapus/{{ $barang->id }}" method="POST" class="d-inline">
                                @csrf
                                @method('DELETE')
                                <input type="button" value="Hapus" class="btn btn-danger btn-delete">
                            </form>
                        </div>
                        </div>
                        </div>
                     </div>
                     @endforeach
               </div>
            </div>
         </div>
      </div>
      <!-- product section end -->
      <!-- footer section start -->
      <div class="footer_section layout_padding">
         <div class="container">
            <div class="row">
               <div class="col-lg-6 col-sm-12">
                  <h4 class="information_text">Komptech</h4>
                  <p class="dummy_text">Komptech adalah aplikasi berbasis web tentang toko online dan menjual berbagai komponen-konponen komputer, dan web ini hanyalah sebuah projek percobaan yang dikerjakan oleh satu orang(full Stack)</p>
               </div>
               <div class="col-lg-3 col-sm-6">
                  <div class="information_main">
                     <h4 class="information_text">Pembuat</h4>
                     <p class="many_text">Kwanzaa(FullStack)</p>
                  </div>
               </div>
               <div class="col-lg-3 col-sm-6">
                  <div class="information_main">
                     <h4 class="information_text">Contact Us</h4>
                     <p class="call_text"><a href="#">+62 0987654321</a></p>
                     <p class="call_text"><a href="#">+62 123456789</a></p>
                     <p class="call_text"><a href="#">arsal@gmail.com</a></p>
                     <div class="social_icon">
                        <ul>
                           <li><a href="https://www.facebook.com/arsal.farullah.1?mibextid=ZbWKwL"><img src="{{ asset('assets/images/fb-icon.png') }}"></a></li>
                           <li><a href="https://www.linkedin.com/in/arsal-fahrulloh-781097290?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app"><img src="{{ asset('assets/images/linkedin-icon.png') }}"></a></li>
                           <li><a href="https://www.instagram.com/arsalfrlh_?igsh=bjdsbDdwbml3cTNt"><img src="{{ asset('assets/images/instagram-icon.png') }}"></a></li>
                        </ul>
                     </div>
                  </div>
               </div>
            </div>
            <div class="copyright_section">
               <h1 class="copyright_text">
               Copyright 2024 By Kwanzaa
            </div>
         </div>
      </div>

      
      <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        @if ($pesan = Session::get('tambah'))
            <script>
            Swal.fire({
            position: "center",
            icon: "success",
            title: '{{ $pesan }}',
            showConfirmButton: false,
            timer: 1500
            });
            </script>
        @endif

        @if ($pesan = Session::get('update'))
            <script>
            Swal.fire({
            position: "center",
            icon: "success",
            title: '{{ $pesan }}',
            showConfirmButton: false,
            timer: 1500
            });
            </script>
        @endif

        @if ($pesan = Session::get('hapus'))
            <script>
            Swal.fire({
            position: "center",
            icon: "success",
            title: '{{ $pesan }}',
            showConfirmButton: false,
            timer: 1500
            });
            </script>
        @endif

        <script type="text/javascript">
        $(function(){
            $(document).on('click', '.btn-delete', function(e){ //nama button di form hapus
                e.preventDefault();
                var form = $(this).closest('form'); // Mendapatkan form terdekat

                Swal.fire({
                    title: "Are you sure?",
                    text: "You won't be able to revert this!",
                    icon: "warning",
                    showCancelButton: true,
                    confirmButtonColor: "#3085d6",
                    cancelButtonColor: "#d33",
                    confirmButtonText: "Yes, delete it!"
                }).then((result) => {
                    if (result.isConfirmed) {
                        form.submit(); // Menjalankan submit form jika konfirmasi
                    }
                });
            });
        });
    </script>
      <!-- footer section end -->
      <!-- Javascript files-->
      <script src="{{ asset('assets/js/jquery.min.js') }}"></script>
      <script src="{{ asset('assets/js/popper.min.js') }}"></script>
      <script src="{{ asset('assets/js/bootstrap.bundle.min.js') }}"></script>
      <script src="{{ asset('assets/js/jquery-3.0.0.min.js') }}"></script>
      <script src="{{ asset('assets/js/plugin.js') }}"></script>
      <!-- sidebar -->
      <script src="{{ asset('assets/js/jquery.mCustomScrollbar.concat.min.js') }}"></script>
      <script src="{{ asset('assets/js/custom.js') }}"></script>
      <!-- javascript --> 
      <script src="{{ asset('assets/js/owl.carousel.js') }}"></script>
      <script src="https:cdnjs.cloudflare.com/ajax/libs/fancybox/2.1.5/jquery.fancybox.min.js"></script> 
      <script type="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2//2.0.0-beta.2.4/owl.carousel.min.js"></script>
      <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
      <script>window.jQuery || document.write('<script src="{{ asset('assets/js/vendor/jquery-slim.min.js') }}"><\/script>')</script>
      <script src="{{ asset('assets/js/vendor/popper.min.js') }}"></script>
      <script src="{{ asset('dist/js/bootstrap.min.js') }}"></script>
   </body>
</html>

