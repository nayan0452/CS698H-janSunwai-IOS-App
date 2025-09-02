package com.example.myapplication

import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.Button
import android.widget.Spinner
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {

    private lateinit var languageSpinner: Spinner
    private lateinit var loginButton: Button
    private lateinit var registerButton: Button
    private lateinit var trackComplaintButton: Button
    private lateinit var helpButton: Button

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // Initialize views
        languageSpinner = findViewById(R.id.language_spinner)
        loginButton = findViewById(R.id.login_button)
        registerButton = findViewById(R.id.register_button)
        trackComplaintButton = findViewById(R.id.track_complaint_button)
        helpButton = findViewById(R.id.help_button)

        // Setup language spinner
        setupLanguageSpinner()

        // Setup click listeners
        loginButton.setOnClickListener {
            startActivity(Intent(this, LoginActivity::class.java))
        }

        registerButton.setOnClickListener {
            startActivity(Intent(this, RegisterComplaintActivity::class.java))
        }

        trackComplaintButton.setOnClickListener {
            startActivity(Intent(this, TrackComplaintActivity::class.java))
        }

        helpButton.setOnClickListener {
            showHelpDialog()
        }
    }

    private fun setupLanguageSpinner() {
        val languages = arrayOf("English", "हिंदी")
        val adapter = ArrayAdapter(this, android.R.layout.simple_spinner_item, languages)
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        languageSpinner.adapter = adapter

        languageSpinner.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(parent: AdapterView<*>, view: View, position: Int, id: Long) {
                val selectedLanguage = parent.getItemAtPosition(position).toString()
                // In a real app, this would change the app's language
                Toast.makeText(
                    this@MainActivity,
                    "Language changed to $selectedLanguage",
                    Toast.LENGTH_SHORT
                ).show()
            }

            override fun onNothingSelected(parent: AdapterView<*>) {
                // Nothing to do
            }
        }
    }

    private fun showHelpDialog() {
        AlertDialog.Builder(this)
            .setTitle("Help & Support")
            .setMessage("This is a prototype of an improved JanSunwai app addressing key usability issues:\n\n" +
                    "• Simplified navigation\n" +
                    "• Consistent language support\n" +
                    "• Improved form design\n" +
                    "• Better feedback system\n" +
                    "• Reduced permission requests\n\n" +
                    "For further assistance, contact support@jansunwai.gov.in")
            .setPositiveButton("OK") { dialog, _ -> dialog.dismiss() }
            .show()
    }
} 