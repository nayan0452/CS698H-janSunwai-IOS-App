package com.example.myapplication

import android.os.Bundle
import android.view.View
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.Button
import android.widget.EditText
import android.widget.Spinner
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity

class RegisterComplaintActivity : AppCompatActivity() {

    private lateinit var departmentSpinner: Spinner
    private lateinit var areaTypeSpinner: Spinner
    private lateinit var subjectEditText: EditText
    private lateinit var descriptionEditText: EditText
    private lateinit var attachButton: Button
    private lateinit var submitButton: Button
    private lateinit var searchDepartmentEditText: EditText
    private lateinit var departmentErrorText: TextView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_register_complaint)

        // Initialize views
        departmentSpinner = findViewById(R.id.department_spinner)
        areaTypeSpinner = findViewById(R.id.area_type_spinner)
        subjectEditText = findViewById(R.id.subject_edit_text)
        descriptionEditText = findViewById(R.id.description_edit_text)
        attachButton = findViewById(R.id.attach_button)
        submitButton = findViewById(R.id.submit_button)
        searchDepartmentEditText = findViewById(R.id.search_department_edit_text)
        departmentErrorText = findViewById(R.id.department_error_text)

        // Setup spinners
        setupDepartmentSpinner()
        setupAreaTypeSpinner()

        // Setup click listeners
        attachButton.setOnClickListener {
            // In a real app, this would trigger file selection
            Toast.makeText(this, "File attachment option (supports multiple files up to 5MB each)", Toast.LENGTH_SHORT).show()
        }

        submitButton.setOnClickListener {
            if (validateForm()) {
                // Simulate form submission
                Toast.makeText(this, "Complaint registered successfully! Your complaint ID is JSCMP-2023-12345", Toast.LENGTH_LONG).show()
                finish()
            }
        }

        // Setup search functionality for departments
        searchDepartmentEditText.setOnFocusChangeListener { _, hasFocus ->
            if (hasFocus) {
                departmentSpinner.performClick()
            }
        }
    }

    private fun setupDepartmentSpinner() {
        // Bi-lingual department list to address language issues
        val departments = arrayOf(
            "Select Department / विभाग चुनें",
            "Public Works / लोक निर्माण विभाग",
            "Healthcare / स्वास्थ्य सेवा",
            "Education / शिक्षा",
            "Police / पुलिस",
            "Water / जल विभाग",
            "Electricity / बिजली विभाग",
            "Railways / रेलवे",
            "Revenue / राजस्व",
            "Urban Development / शहरी विकास",
            "Rural Development / ग्रामीण विकास"
        )

        val adapter = ArrayAdapter(this, android.R.layout.simple_spinner_item, departments)
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        departmentSpinner.adapter = adapter

        departmentSpinner.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(parent: AdapterView<*>, view: View, position: Int, id: Long) {
                if (position == 0) {
                    departmentErrorText.visibility = View.VISIBLE
                } else {
                    departmentErrorText.visibility = View.GONE
                }
            }

            override fun onNothingSelected(parent: AdapterView<*>) {
                departmentErrorText.visibility = View.VISIBLE
            }
        }
    }

    private fun setupAreaTypeSpinner() {
        val areaTypes = arrayOf("Urban / शहरी", "Rural / ग्रामीण")
        val adapter = ArrayAdapter(this, android.R.layout.simple_spinner_item, areaTypes)
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        areaTypeSpinner.adapter = adapter
    }

    private fun validateForm(): Boolean {
        var valid = true

        if (departmentSpinner.selectedItemPosition == 0) {
            departmentErrorText.visibility = View.VISIBLE
            valid = false
        } else {
            departmentErrorText.visibility = View.GONE
        }

        if (subjectEditText.text.toString().trim().isEmpty()) {
            subjectEditText.error = "Please enter a subject"
            valid = false
        }

        if (descriptionEditText.text.toString().trim().isEmpty()) {
            descriptionEditText.error = "Please enter a description"
            valid = false
        }

        return valid
    }
} 