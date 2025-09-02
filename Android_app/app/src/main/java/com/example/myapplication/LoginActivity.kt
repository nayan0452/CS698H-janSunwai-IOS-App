package com.example.myapplication

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity

class LoginActivity : AppCompatActivity() {

    private lateinit var mobileEditText: EditText
    private lateinit var otpEditText: EditText
    private lateinit var sendOtpButton: Button
    private lateinit var loginButton: Button
    private lateinit var forgotNumberButton: Button

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_login)

        // Initialize views
        mobileEditText = findViewById(R.id.mobile_edit_text)
        otpEditText = findViewById(R.id.otp_edit_text)
        sendOtpButton = findViewById(R.id.send_otp_button)
        loginButton = findViewById(R.id.login_button)
        forgotNumberButton = findViewById(R.id.forgot_number_button)

        // Setup click listeners
        sendOtpButton.setOnClickListener {
            val mobileNumber = mobileEditText.text.toString()
            if (isValidMobileNumber(mobileNumber)) {
                // Simulate OTP sending
                Toast.makeText(this, "OTP sent to $mobileNumber", Toast.LENGTH_SHORT).show()
                otpEditText.isEnabled = true
                loginButton.isEnabled = true
            } else {
                mobileEditText.error = "Please enter a valid 10-digit mobile number"
            }
        }

        loginButton.setOnClickListener {
            val otp = otpEditText.text.toString()
            if (otp.length == 6) {
                // Simulate login success
                Toast.makeText(this, "Login successful", Toast.LENGTH_SHORT).show()
                startActivity(Intent(this, DashboardActivity::class.java))
                finish()
            } else {
                otpEditText.error = "Please enter valid 6-digit OTP"
            }
        }

        forgotNumberButton.setOnClickListener {
            // Show help dialog or navigate to help page
            Toast.makeText(this, "Help feature will be implemented here", Toast.LENGTH_SHORT).show()
        }
    }

    private fun isValidMobileNumber(mobile: String): Boolean {
        return mobile.length == 10 && mobile.all { it.isDigit() }
    }
} 