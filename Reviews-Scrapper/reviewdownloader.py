import csv
import re

def parse_reviews(input_file, output_file):
    # Read the entire file content
    with open(input_file, 'r', encoding='utf-8') as file:
        content = file.read()
    
    # Split the content by "Did you find this helpful?" to get individual reviews
    reviews = content.split("Did you find this helpful?")
    reviews = [r.strip() for r in reviews if r.strip()]
    
    # Create CSV file
    with open(output_file, 'w', encoding='utf-8', newline='') as csvfile:
        csv_writer = csv.writer(csvfile, quoting=csv.QUOTE_MINIMAL)
        # Write header
        csv_writer.writerow(['Name', 'Date', 'Review', 'People_Found_Helpful'])
        
        # Process each review
        for review in reviews:
            lines = review.split('\n')
            name = lines[0].strip()
            date = lines[1].strip()
            
            # Find the line with "people found this review helpful"
            helpful_pattern = re.compile(r'(\d+) people found this review helpful')
            helpful_count = 0
            review_lines = []
            
            for i, line in enumerate(lines[2:]):
                match = helpful_pattern.search(line)
                if match:
                    helpful_count = int(match.group(1))
                    review_text = '\n'.join(lines[2:i+2]).strip()
                    break
            else:
                # If no helpful count found, assume the review text is everything between date and end
                review_text = '\n'.join(lines[2:]).strip()
            
            # Handle case where no one found review helpful
            if not review_text:
                review_text = '\n'.join(lines[2:-1]).strip()
                helpful_count = 0
            
            # Write to CSV
            csv_writer.writerow([name, date, review_text, helpful_count])
    
    print(f"Successfully converted {len(reviews)} reviews to {output_file}")

if __name__ == "__main__":
    parse_reviews("reviews.txt", "reviews.csv")