<!DOCTYPE html>
<html lang="en">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css">
  <link rel="stylesheet" href="{{ asset('assets/css/form.css') }}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
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

      {{-- config midtrans --}}
      <script type="text/javascript"
      src="https://app.sandbox.midtrans.com/snap/snap.js"
      data-client-key="{{ config('midtrans.client_key') }}"></script>
    <!-- SweetAlert2 CDN -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
</head>
<body>
  <form action="/beli/tambah/proses" method="post">
    @csrf
    @foreach ($tampil as $barang)
    <div class="beauty_section layout_padding">
         <div class="container">
            <div class="row">
               <div class="col-lg-4 col-sm-12">
                  <div class="beauty_box">
                     <div><img src="{{ asset('images/'.$barang->gambar) }}" class="image_3"></div>
                  </div>
               </div>
               <div class="col-lg-8 col-sm-12">
                  <div class="beauty_box_1">
                  <div class="nice-form-group col-md-12">
                    <label>Nama Barang</label>
                    <input type="text" placeholder="Nama Barang" value="{{ $barang->nama_barang }}" readonly required />
                    <input type="hidden" value="{{ $barang->id }}" name="id_barang">
                  </div>

                  <div class="nice-form-group col-md-12">
                    <label>Tanggal Beli</label>
                    <input type="date" value="{{ now()->format('Y-m-d') }}" readonly />
                    </div>

                  <div class="nice-form-group col-md-12">
                    <label>Harga</label>
                    <input type="number" placeholder="RP" value="{{ $barang->harga }}" readonly required />
                  </div>
                    
                  <div class="nice-form-group col-md-12">
                    <label>Jumlah Beli</label>
                    <input type="number" placeholder="Jumlah Beli" name="jumlah" value="" required />
                  </div>

                  <div class="nice-form-group col-md-12">
                    <input type="submit" value="Beli" class="btn btn-success" />
                    <a href="/barang" class="btn btn-danger">Kembali</a>
                  </div>
                  </div>
               </div>
            </div>
         </div>
      </div>
      @endforeach
  </form>

        {{-- jika ada snap token --}}
  @if (Session::get('snapToken'))
       <script type="text/javascript">
      // Token transaksi dari server
      var snapToken = "{{ Session::get('snapToken') }}"; //snapToken dari session (with) controller tadi

      // Tampilkan SweetAlert dan panggil Midtrans Snap dari dalamnya
      Swal.fire({
        title: "Lanjutkan Pembayaran?",
        text: "Klik OK untuk membayar",
        icon: "info",
        showCancelButton: true,
        confirmButtonText: "Bayar Sekarang",
        cancelButtonText: "Batal"
      }).then((result) => {
            if (result.isConfirmed) {
              window.snap.pay(snapToken, {
                onSuccess: function(result){
                Swal.fire("Berhasil!", "Pembayaran sukses!", "success");

                // Kirim data ke server dengan fetch
                fetch("{{ url('/beli/payment') }}", {
                  method: "POST",
                  headers: {
                    "Content-Type": "application/json",
                    "X-CSRF-TOKEN": "{{ csrf_token() }}" // penting untuk Laravel
                  },
                  body: JSON.stringify(result) // result dari Midtrans Snap
              })
              .then(data => {
                window.location.href = "{{ url('/beli') }}"; //redirect ke halman beli
              })
              .catch(error => {
                console.error("Error mengirim data ke server:", error); 
              });
            },
            onPending: function(result){
              Swal.fire("Menunggu...", "Pembayaran belum selesai.", "warning");
              console.log(result);
            },
            onError: function(result){
              Swal.fire("Gagal!", "Pembayaran gagal.", "error");
              console.log(result);
            },
            onClose: function(){
              Swal.fire("Ditutup", "Kamu menutup popup sebelum menyelesaikan pembayaran", "info");
            }
          });
        } else {
          Swal.fire("Dibatalkan", "Pembayaran dibatalkan.", "error");
        }
      });
    </script>
  @endif

  @if ($pesan = Session::get('gagal'))
      <script>Swal.fire("{{ $pesan }}");</script>
  @endif
</body>
</html>