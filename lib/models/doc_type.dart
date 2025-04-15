import 'package:uuid/uuid.dart';

class DoctorType {
  final String docId,
      docTitle,
      docPrice,
      docCategory,
      docDescription,
      docImage,
      docQuantity;

  DoctorType({
    required this.docId,
    required this.docTitle,
    required this.docPrice,
    required this.docCategory,
    required this.docDescription,
    required this.docImage,
    required this.docQuantity,
  });

  static List<DoctorType> doctors = [
    DoctorType(
      docId: 'psychiatrist-001',
      docTitle: "Dr. Sophia Bennett - Psychiatrist",
      docPrice: "150.00",
      docCategory: "Psychiatrist",
      docDescription:
      "Dr. Sophia Bennett is a licensed psychiatrist with over 10 years of experience in treating anxiety, depression, and mood disorders. She combines therapy and medication management to guide patients toward mental clarity.",
      docImage: "https://i.ibb.co/5cK1gHQ/doctor-sophia.png",
      docQuantity: "5",
    ),
    DoctorType(
      docId: 'therapist-002',
      docTitle: "Dr. Ryan Mitchell - Clinical Psychologist",
      docPrice: "120.00",
      docCategory: "Therapist",
      docDescription:
      "Dr. Ryan Mitchell specializes in cognitive-behavioral therapy and mindfulness-based stress reduction. He works with teens and adults to manage stress, trauma, and emotional regulation.",
      docImage: "https://i.ibb.co/ZYW3VTp/doctor-ryan.png",
      docQuantity: "8",
    ),
    DoctorType(
      docId: 'counselor-003',
      docTitle: "Dr. Aisha Khan - Mental Health Counselor",
      docPrice: "90.00",
      docCategory: "Counselor",
      docDescription:
      "Dr. Aisha Khan focuses on relationship counseling, self-esteem building, and coping strategies. She offers a compassionate and non-judgmental approach for young adults and couples.",
      docImage: "https://i.ibb.co/cY4ZL9W/doctor-aisha.png",
      docQuantity: "6",
    ),
    DoctorType(
      docId: const Uuid().v4(),
      docTitle: "Dr. Marcus Lee - Behavioral Therapist",
      docPrice: "100.00",
      docCategory: "Therapist",
      docDescription:
      "Dr. Marcus Lee provides behavioral therapy for individuals with anxiety, phobias, and OCD. He uses evidence-based techniques to support sustainable mental health improvements.",
      docImage: "https://i.ibb.co/kHZzMZ5/doctor-marcus.png",
      docQuantity: "7",
    ),
    DoctorType(
      docId: const Uuid().v4(),
      docTitle: "Dr. Emily Tran - Child & Adolescent Psychiatrist",
      docPrice: "160.00",
      docCategory: "Psychiatrist",
      docDescription:
      "Dr. Emily Tran offers specialized psychiatric care for children and teens facing ADHD, anxiety, and behavioral challenges. She works closely with families to provide holistic mental health solutions.",
      docImage: "https://i.ibb.co/QfBn3ZR/doctor-emily.png",
      docQuantity: "4",
    ),
  ];
}
