package com.example.e_garage;

import android.os.Bundle;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import com.mercadopago.android.px.core.MercadoPagoCheckout;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.e_garage/mercadoPago";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler((call, result) -> {
                if (call.method.equals("mercadoPago")) {
                    String publicKey = call.argument("publicKey");
                    String preferenceId = call.argument("preferenceId");

                    startMercadoPago(publicKey, preferenceId, result);
                } else {
                    result.notImplemented();
                }
            });
    }

    private void startMercadoPago(String publicKey, String preferenceId, MethodChannel.Result result) {
        try {
            new MercadoPagoCheckout.Builder(publicKey, preferenceId).build().startPayment(this, 1);
            result.success("Payment initiated");
        } catch (Exception e) {
            result.error("ERROR", "Error initiating Mercado Pago: " + e.getMessage(), null);
        }
    }
}
