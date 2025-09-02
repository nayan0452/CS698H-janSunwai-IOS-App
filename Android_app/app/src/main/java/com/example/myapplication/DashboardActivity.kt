package com.example.myapplication

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity

class DashboardActivity : AppCompatActivity() {

    private lateinit var registerComplaintButton: Button
    private lateinit var trackComplaintButton: Button
    private lateinit var viewProfileButton: Button
    private lateinit var logoutButton: Button

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_dashboard)

        // Initialize views
        registerComplaintButton = findViewById(R.id.register_complaint_button)
        trackComplaintButton = findViewById(R.id.track_complaint_button)
        viewProfileButton = findViewById(R.id.view_profile_button)
        logoutButton = findViewById(R.id.logout_button)

        // Setup click listeners
        registerComplaintButton.setOnClickListener {
            startActivity(Intent(this, RegisterComplaintActivity::class.java))
        }

        trackComplaintButton.setOnClickListener {
            startActivity(Intent(this, TrackComplaintActivity::class.java))
        }

        viewProfileButton.setOnClickListener {
            // In a real app, this would navigate to a profile screen
        }

        logoutButton.setOnClickListener {
            // In a real app, this would clear session data
            finish()
        }
    }
} 