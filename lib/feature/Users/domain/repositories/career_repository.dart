import 'package:dartz/dartz.dart';
import '../entities/career.dart';
import '../../../../core/error/failures.dart';

abstract class CareerRepository {
  Future<Either<Failure, List<Career>>> getAllCareers();
  
  Future<Either<Failure, List<Career>>> getCareersByCategory(String category);
  
  Future<Either<Failure, Career>> getCareerById(String id);
  
  Future<Either<Failure, List<Career>>> getRecommendedCareers(String userId);
  
  Future<Either<Failure, List<Career>>> searchCareers(String query);
}
