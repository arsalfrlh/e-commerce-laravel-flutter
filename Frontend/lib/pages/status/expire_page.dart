import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latihan/pages/home_page.dart';

class ExpirePage extends StatefulWidget {
  const ExpirePage({super.key});

  @override
  State<ExpirePage> createState() => _ExpirePageState();
}

class _ExpirePageState extends State<ExpirePage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: 'Kadaluarsa',
        desc: 'Pembayaran Anda telah Kadaluarsa',
        btnOkOnPress: (){},
        btnOkColor: Colors.red,
      ).show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Spacer(flex: 2),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: SvgPicture.string(
                    cardExpiredIllistration,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              const Spacer(flex: 2),
              ErrorInfo(
                title: "Payment Expired!",
                description:
                    "It looks like your payment is expired. Please enter new payment details to proceed.",
                btnText: "Kembali",
                press: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorInfo extends StatelessWidget {
  const ErrorInfo({
    super.key,
    required this.title,
    required this.description,
    this.button,
    this.btnText,
    required this.press,
  });

  final String title;
  final String description;
  final Widget? button;
  final String? btnText;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16 * 2.5),
            button ??
                ElevatedButton(
                  onPressed: press,
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)))),
                  child: Text(btnText ?? "Retry".toUpperCase()),
                ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

const cardExpiredIllistration =
    '''<svg width="1080" height="1080" viewBox="0 0 1080 1080" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M695.31 633.31C811.842 633.31 906.31 538.842 906.31 422.31C906.31 305.778 811.842 211.31 695.31 211.31C578.778 211.31 484.31 305.778 484.31 422.31C484.31 538.842 578.778 633.31 695.31 633.31Z" fill="#E2E2E2"/>
<path d="M748.06 397.61H321.89C315.832 397.61 310.92 402.521 310.92 408.58V676.36C310.92 682.418 315.832 687.33 321.89 687.33H748.06C754.119 687.33 759.03 682.418 759.03 676.36V408.58C759.03 402.521 754.119 397.61 748.06 397.61Z" fill="white"/>
<path d="M748.06 397.61H321.89C315.832 397.61 310.92 402.521 310.92 408.58V676.36C310.92 682.418 315.832 687.33 321.89 687.33H748.06C754.119 687.33 759.03 682.418 759.03 676.36V408.58C759.03 402.521 754.119 397.61 748.06 397.61Z" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M695.31 493.94C713.486 493.94 728.22 479.206 728.22 461.03C728.22 442.854 713.486 428.12 695.31 428.12C677.134 428.12 662.4 442.854 662.4 461.03C662.4 479.206 677.134 493.94 695.31 493.94Z" fill="#8C8C8C"/>
<path d="M679.858 484.309C692.71 471.457 692.71 450.619 679.858 437.767C667.006 424.915 646.168 424.915 633.316 437.767C620.464 450.619 620.464 471.457 633.316 484.309C646.168 497.161 667.006 497.161 679.858 484.309Z" fill="#D3D3D3"/>
<path d="M415.26 493.03H357.05C353.792 493.03 351.15 495.672 351.15 498.93V529.72C351.15 532.979 353.792 535.62 357.05 535.62H415.26C418.519 535.62 421.16 532.979 421.16 529.72V498.93C421.16 495.672 418.519 493.03 415.26 493.03Z" fill="#D3D3D3"/>
<path d="M351.15 639.69H416.12" stroke="#8C8C8C" stroke-width="9" stroke-miterlimit="10" stroke-linecap="round"/>
<path d="M451.64 639.69H516.6" stroke="#8C8C8C" stroke-width="9" stroke-miterlimit="10" stroke-linecap="round"/>
<path d="M551.04 639.69H616.01" stroke="#8C8C8C" stroke-width="9" stroke-miterlimit="10" stroke-linecap="round"/>
<path d="M653.82 639.69H718.79" stroke="#8C8C8C" stroke-width="9" stroke-miterlimit="10" stroke-linecap="round"/>
<path d="M853.34 728.32C861.194 728.32 867.56 721.953 867.56 714.1C867.56 706.246 861.194 699.88 853.34 699.88C845.487 699.88 839.12 706.246 839.12 714.1C839.12 721.953 845.487 728.32 853.34 728.32Z" fill="#E2E2E2"/>
<path d="M835.85 790.22C845.51 790.22 853.34 782.39 853.34 772.73C853.34 763.071 845.51 755.24 835.85 755.24C826.191 755.24 818.36 763.071 818.36 772.73C818.36 782.39 826.191 790.22 835.85 790.22Z" fill="#E2E2E2"/>
<path d="M894.43 779.01C900.991 779.01 906.31 773.691 906.31 767.13C906.31 760.569 900.991 755.25 894.43 755.25C887.869 755.25 882.55 760.569 882.55 767.13C882.55 773.691 887.869 779.01 894.43 779.01Z" fill="#E2E2E2"/>
<path d="M192.84 710.261C197.872 704.231 197.062 695.264 191.032 690.233C185.001 685.201 176.034 686.011 171.003 692.041C165.972 698.072 166.781 707.039 172.812 712.07C178.842 717.101 187.809 716.291 192.84 710.261Z" fill="#E2E2E2"/>
<path d="M229.163 763.342C235.351 755.925 234.356 744.896 226.939 738.707C219.522 732.519 208.493 733.515 202.304 740.932C196.116 748.349 197.112 759.378 204.529 765.566C211.946 771.755 222.975 770.759 229.163 763.342Z" fill="#E2E2E2"/>
<path d="M258.072 711.191C262.275 706.153 261.599 698.661 256.561 694.458C251.523 690.255 244.031 690.931 239.828 695.969C235.625 701.007 236.301 708.498 241.339 712.702C246.377 716.905 253.868 716.229 258.072 711.191Z" fill="#E2E2E2"/>
<path d="M254.679 291.315C255.507 292.143 255.899 293.102 255.856 294.192C255.899 295.282 255.507 296.241 254.679 297.069C253.85 297.898 252.87 298.312 251.736 298.312C250.69 298.312 249.752 297.898 248.924 297.069L238.723 286.868L228.587 297.004C227.759 297.832 226.778 298.246 225.644 298.246C224.554 298.29 223.595 297.898 222.767 297.069C221.939 296.241 221.524 295.26 221.524 294.127C221.568 293.037 222.004 292.078 222.832 291.249L232.968 281.113L222.767 270.912C221.939 270.084 221.503 269.125 221.459 268.035C221.503 266.945 221.939 265.986 222.767 265.157C223.595 264.329 224.533 263.915 225.579 263.915C226.712 263.915 227.693 264.329 228.521 265.157L238.723 275.359L248.924 265.157C249.752 264.329 250.69 263.915 251.736 263.915C252.87 263.915 253.85 264.329 254.679 265.157C255.507 265.986 255.899 266.945 255.856 268.035C255.899 269.125 255.507 270.084 254.679 270.912L244.477 281.113L254.679 291.315Z" fill="#727272"/>
<path d="M275.402 824.091C276.635 825.324 277.219 826.752 277.154 828.374C277.219 829.996 276.635 831.424 275.402 832.657C274.169 833.89 272.709 834.506 271.022 834.506C269.465 834.506 268.07 833.89 266.837 832.657L251.653 817.473L236.566 832.559C235.333 833.792 233.873 834.409 232.186 834.409C230.564 834.474 229.136 833.89 227.903 832.657C226.671 831.424 226.054 829.964 226.054 828.277C226.119 826.654 226.768 825.227 228.001 823.994L243.087 808.907L227.903 793.723C226.671 792.49 226.022 791.063 225.957 789.441C226.022 787.818 226.671 786.391 227.903 785.158C229.136 783.925 230.531 783.309 232.089 783.309C233.776 783.309 235.236 783.925 236.469 785.158L251.653 800.342L266.837 785.158C268.07 783.925 269.465 783.309 271.022 783.309C272.709 783.309 274.169 783.925 275.402 785.158C276.635 786.391 277.219 787.818 277.154 789.441C277.219 791.063 276.635 792.49 275.402 793.723L260.218 808.907L275.402 824.091Z" fill="#727272"/>
<path d="M460.15 732.37L525.32 607.49C526.142 605.913 527.377 604.589 528.895 603.662C530.412 602.735 532.154 602.239 533.932 602.228C535.71 602.216 537.458 602.69 538.987 603.598C540.516 604.506 541.769 605.813 542.61 607.38L609.74 732.26C610.541 733.75 610.941 735.421 610.903 737.112C610.865 738.803 610.388 740.455 609.521 741.906C608.654 743.358 607.425 744.56 605.954 745.395C604.483 746.23 602.821 746.669 601.13 746.67H468.82C467.139 746.669 465.487 746.236 464.023 745.411C462.558 744.586 461.331 743.398 460.46 741.96C459.589 740.523 459.102 738.886 459.048 737.206C458.994 735.526 459.373 733.86 460.15 732.37Z" fill="#ABABAB" stroke="#0E0E0E" stroke-width="3" stroke-miterlimit="10"/>
<path d="M535.56 707.09H534C530.14 707.09 523.48 703.94 523.48 700.09L527 645.56C527 643.704 527.738 641.923 529.05 640.61C530.363 639.298 532.144 638.56 534 638.56H535.56C537.417 638.56 539.197 639.298 540.51 640.61C541.823 641.923 542.56 643.704 542.56 645.56L546.45 700.08C546.46 703.94 539.41 707.09 535.56 707.09Z" fill="white" stroke="#0E0E0E" stroke-width="3" stroke-miterlimit="10"/>
<path d="M534.97 735.32C540.835 735.32 545.59 730.565 545.59 724.7C545.59 718.835 540.835 714.08 534.97 714.08C529.105 714.08 524.35 718.835 524.35 724.7C524.35 730.565 529.105 735.32 534.97 735.32Z" fill="white" stroke="#0E0E0E" stroke-width="3" stroke-miterlimit="10"/>
</svg>
''';