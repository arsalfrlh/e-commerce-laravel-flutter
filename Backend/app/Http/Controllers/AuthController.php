<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function index(){
        return view('main.index');
    }

    public function login(){
        return view('auth.login');
    }

    public function loginProses(Request $request){
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        $login = [
            'email' => $request->email,
            'password' => $request->password,
        ];

        if(Auth::attempt($login)){
            return redirect('/index')->with('login', Auth::user()->name .'Selamat datang anda berhasil login');
        }else{
            return redirect('/login')->with('gagal', 'Email atau Password anda salah');
        }
    }

    public function registerProses(Request $request){
        $request->validate([
            'name' => 'required',
            'email' => 'required|email|unique:users',
            'password' => 'required',
        ]);

        User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
        ]);

        $register = [
            'email' => $request->email,
            'password' => $request->password,
        ];

        if(Auth::attempt($register)){
            return redirect('/index')->with('register', Auth::user()->name . ' Selamat datang anda berhasil register');
        }else{
            return redirect('/register')->with('gagal', 'Register gagal');
        }
    }

    public function logout(){
        Auth::logout();
        return redirect('/login')->with('logout', 'Anda telah logout');
    }
}
