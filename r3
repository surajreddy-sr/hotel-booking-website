import java.io.*;
import java.util.*;
import java.text.SimpleDateFormat;

public class GymSystem {
    private static Scanner scanner = new Scanner(System.in);
    private static SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    
    // File names
    private static final String MEMBERS_FILE = "members.dat";
    private static final String STAFF_FILE = "staff.dat";
    private static final String EQUIPMENT_FILE = "equipment.dat";
    private static final String PAYMENTS_FILE = "payments.dat";

    public static void main(String[] args) {
        while (true) {
            System.out.println("\n=== GYM MANAGEMENT SYSTEM ===");
            System.out.println("1. Member Management");
            System.out.println("2. Staff Management");
            System.out.println("3. Equipment Management");
            System.out.println("4. Payment Management");
            System.out.println("5. Reports");
            System.out.println("6. Exit");
            System.out.print("Enter your choice: ");
            
            int choice = getIntInput();
            
            switch (choice) {
                case 1: memberMenu(); break;
                case 2: staffMenu(); break;
                case 3: equipmentMenu(); break;
                case 4: paymentMenu(); break;
                case 5: reportMenu(); break;
                case 6: 
                    System.out.println("Exiting...");
                    scanner.close();
                    System.exit(0);
                default: 
                    System.out.println("Invalid choice! Please try again.");
            }
        }
    }

    // Member class and operations
    static class Member implements Serializable {
        int id;
        String name, phone, email, type, address, gender;
        Date joinDate, expiryDate, dob;
        
        public Member(int id, String name, String phone, String email, Date joinDate, 
                     String type, Date expiryDate, String address, String gender, Date dob) {
            this.id = id;
            this.name = name;
            this.phone = phone;
            this.email = email;
            this.joinDate = joinDate;
            this.type = type;
            this.expiryDate = expiryDate;
            this.address = address;
            this.gender = gender;
            this.dob = dob;
        }
        
        public String toString() {
            return String.format("ID: %d | Name: %s | Phone: %s | Email: %s | Type: %s | Join: %s | Expiry: %s",
                   id, name, phone, email, type, dateFormat.format(joinDate), dateFormat.format(expiryDate));
        }
    }

    static void memberMenu() {
        while (true) {
            System.out.println("\n=== MEMBER MANAGEMENT ===");
            System.out.println("1. Add Member");
            System.out.println("2. View Members");
            System.out.println("3. Update Member");
            System.out.println("4. Delete Member");
            System.out.println("5. Search Members");
            System.out.println("6. Back to Main Menu");
            System.out.print("Enter choice: ");
            
            int choice = getIntInput();
            
            switch (choice) {
                case 1: addMember(); break;
                case 2: viewMembers(); break;
                case 3: updateMember(); break;
                case 4: deleteMember(); break;
                case 5: searchMembers(); break;
                case 6: return;
                default: System.out.println("Invalid choice!");
            }
        }
    }

    static void addMember() {
        try {
            System.out.println("\nAdd New Member");
            int id = generateId(MEMBERS_FILE);
            
            System.out.print("Name: ");
            String name = scanner.nextLine();
            
            System.out.print("Phone: ");
            String phone = scanner.nextLine();
            
            System.out.print("Email: ");
            String email = scanner.nextLine();
            
            System.out.print("Address: ");
            String address = scanner.nextLine();
            
            System.out.print("Gender (M/F/O): ");
            String gender = scanner.nextLine();
            
            System.out.print("Date of Birth (YYYY-MM-DD): ");
            Date dob = dateFormat.parse(scanner.nextLine());
            
            System.out.print("Membership Type: ");
            String type = scanner.nextLine();
            
            System.out.print("Join Date (YYYY-MM-DD): ");
            Date joinDate = dateFormat.parse(scanner.nextLine());
            
            System.out.print("Expiry Date (YYYY-MM-DD): ");
            Date expiryDate = dateFormat.parse(scanner.nextLine());
            
            Member newMember = new Member(id, name, phone, email, joinDate, type, expiryDate, address, gender, dob);
            
            List<Member> members = readMembers();
            members.add(newMember);
            saveMembers(members);
            
            System.out.println("Member added successfully! ID: " + id);
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }

    // Similar simplified methods for other operations...
    // Staff, Equipment, Payment classes and operations would follow same pattern

    // Helper methods
    @SuppressWarnings("unchecked")
    static <T> List<T> readFromFile(String filename) {
        try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(filename))) {
            return (List<T>) ois.readObject();
        } catch (FileNotFoundException e) {
            return new ArrayList<>();
        } catch (Exception e) {
            System.out.println("Error reading file: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    static <T> void saveToFile(String filename, List<T> data) {
        try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(filename))) {
            oos.writeObject(data);
        } catch (Exception e) {
            System.out.println("Error saving file: " + e.getMessage());
        }
    }

    static List<Member> readMembers() { return readFromFile(MEMBERS_FILE); }
    static void saveMembers(List<Member> data) { saveToFile(MEMBERS_FILE, data); }
    
    static int getIntInput() {
        while (!scanner.hasNextInt()) {
            System.out.print("Please enter a number: ");
            scanner.next();
        }
        int num = scanner.nextInt();
        scanner.nextLine(); // Clear buffer
        return num;
    }

    static int generateId(String filename) {
        List<?> items = readFromFile(filename);
        return items.size() + 1;
    }
}