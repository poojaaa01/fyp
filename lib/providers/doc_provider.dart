import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/doc_type.dart';

class DocProvider with ChangeNotifier {

  List<DoctorType> get getDoctors {
    return doctors;
  }

  DoctorType? findByDocId (String docId){
    if(doctors.where((element) => element.docId == docId).isEmpty){
      return null;
    }
    return doctors.firstWhere((element) => element.docId == docId);
  }

  List<DoctorType> searchQuery({required String searchText}) {
    List<DoctorType> searchList = doctors
        .where(
          (element) => element.docTitle.toLowerCase().contains(
        searchText.toLowerCase(),
      ),
    )
        .toList();
    return searchList;
  }



  List<DoctorType> doctors = [
    DoctorType(
      docId: 'psychiatrist-001',
      docTitle: "Dr. Sophia Bennett - Psychiatrist",
      docPrice: "3500.00",
      docCategory: "Psychiatrist",
      docDescription:
      "Dr. Sophia Bennett is a licensed psychiatrist with over 10 years of experience in treating anxiety, depression, and mood disorders. She combines therapy and medication management to guide patients toward mental clarity.",
      docImage: "https://i.etsystatic.com/19468294/r/il/ec69f9/5951053912/il_570xN.5951053912_1weo.jpg",
      docQuantity: "5",
    ),
    DoctorType(
      docId: 'therapist-002',
      docTitle: "Dr. Ryan Mitchell - Clinical Psychologist",
      docPrice: "1500.00",
      docCategory: "Therapist",
      docDescription:
      "Dr. Ryan Mitchell specializes in cognitive-behavioral therapy and mindfulness-based stress reduction. He works with teens and adults to manage stress, trauma, and emotional regulation.",
      docImage: "https://familydoctor.org/wp-content/uploads/2018/02/41808433_l.jpg",
      docQuantity: "8",
    ),
    DoctorType(
      docId: 'counselor-003',
      docTitle: "Dr. Zehangir Khan - Mental Health Counselor",
      docPrice: "2000.00",
      docCategory: "Counselor",
      docDescription:
      "Dr. Zehangir Khan focuses on relationship counseling, self-esteem building, and coping strategies. He offers a compassionate and non-judgmental approach for young adults and couples.",
      docImage: "https://cdn.dnaindia.com/sites/default/files/styles/full/public/2016/11/24/522526-shah-rukh-dear-zindagi-tu-hi-hai.jpg",
      docQuantity: "6",
    ),
    DoctorType(
      docId: const Uuid().v4(),
      docTitle: "Dr. Marcus Lee - Behavioral Therapist",
      docPrice: "1000.00",
      docCategory: "Therapist",
      docDescription:
      "Dr. Marcus Lee provides behavioral therapy for individuals with anxiety, phobias, and OCD. He uses evidence-based techniques to support sustainable mental health improvements.",
      docImage: "https://i.pinimg.com/736x/2a/0e/8c/2a0e8cb609405d9ca87bc81154b9c443.jpg",
      docQuantity: "7",
    ),
    DoctorType(
      docId: const Uuid().v4(),
      docTitle: "Dr. Emily Tran - Child & Adolescent Psychiatrist",
      docPrice: "500.00",
      docCategory: "Psychiatrist",
      docDescription:
      "Dr. Emily Tran offers specialized psychiatric care for children and teens facing ADHD, anxiety, and behavioral challenges. She works closely with families to provide holistic mental health solutions.",
      docImage: "https://hips.hearstapps.com/hmg-prod/images/portrait-of-a-happy-young-doctor-in-his-clinic-royalty-free-image-1661432441.jpg",
      docQuantity: "4",
    ),
  ];
}