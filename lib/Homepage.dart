// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:mlautismdetection/provider/AutismDetectorProvider.dart';
// import 'package:provider/provider.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Autism Detection'),
//         backgroundColor: Colors.blue,
//         elevation: 0,
//       ),
//       body: Consumer<AutismDetectorProvider>(
//         builder: (context, provider, _) {
//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Image display area
//                   Container(
//                     height: 300,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade200,
//                       borderRadius: BorderRadius.circular(15),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.3),
//                           spreadRadius: 2,
//                           blurRadius: 5,
//                           offset: const Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child:
//                         !provider.hasImage
//                             ? const Center(
//                               child: Text(
//                                 'No image selected',
//                                 style: TextStyle(fontSize: 18),
//                               ),
//                             )
//                             : ClipRRect(
//                               borderRadius: BorderRadius.circular(10),
//                               child: Image.memory(
//                                 provider.imageBytes!,
//                                 fit: BoxFit.contain,
//                               ),
//                             ),
//                   ),

//                   const SizedBox(height: 24),

//                   // Image upload buttons
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       _buildImageSourceButton(
//                         context,
//                         'Camera',
//                         Icons.camera_alt,
//                         () => provider.pickImage(ImageSource.camera),
//                       ),
//                       const SizedBox(width: 20),
//                       _buildImageSourceButton(
//                         context,
//                         'Gallery',
//                         Icons.photo_library,
//                         () => provider.pickImage(ImageSource.gallery),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 24),

//                   // Analyze button
//                   if (provider.hasImage &&
//                       !provider.isLoading &&
//                       !provider.hasResult)
//                     ElevatedButton.icon(
//                       onPressed: () => provider.analyzeImage(),
//                       icon: const Icon(Icons.search),
//                       label: const Text('Analyze Image'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 32,
//                           vertical: 12,
//                         ),
//                         textStyle: const TextStyle(fontSize: 16),
//                       ),
//                     ),

//                   const SizedBox(height: 20),

//                   // Loading indicator
//                   if (provider.isLoading)
//                     Column(
//                       children: [
//                         const CircularProgressIndicator(),
//                         const SizedBox(height: 16),
//                         Text(
//                           'Analyzing image...',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey.shade700,
//                           ),
//                         ),
//                       ],
//                     ),

//                   // Results display
//                   if (provider.hasResult) ...[
//                     Container(
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color:
//                             provider.result!.containsKey('error')
//                                 ? Colors.red.shade100
//                                 : provider.result!['result'] == "Autistic"
//                                 ? Colors.red.shade100
//                                 : Colors.green.shade100,
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: Column(
//                         children: [
//                           if (provider.result!.containsKey('error'))
//                             Text(
//                               'Error: ${provider.result!['error']}',
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.red,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               textAlign: TextAlign.center,
//                             )
//                           else ...[
//                             Text(
//                               provider.result!['result'],
//                               style: TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                                 color:
//                                     provider.result!['result'] == "Autistic"
//                                         ? Colors.red.shade700
//                                         : Colors.green.shade700,
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             Text(
//                               'Confidence: ${(provider.result!['prediction_value'] * 100).toStringAsFixed(2)}%',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.grey.shade800,
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     ElevatedButton.icon(
//                       onPressed: () => provider.resetState(),
//                       icon: const Icon(Icons.refresh),
//                       label: const Text('Start Over'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.grey.shade700,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 24,
//                           vertical: 12,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildImageSourceButton(
//     BuildContext context,
//     String text,
//     IconData icon,
//     VoidCallback onPressed,
//   ) {
//     return ElevatedButton.icon(
//       onPressed: onPressed,
//       icon: Icon(icon),
//       label: Text(text),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.blue,
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//       ),
//     );
//   }
// }
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mlautismdetection/provider/AutismDetectorProvider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = kIsWeb;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Autism Detection',
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.cyan.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.grey.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Consumer<AutismDetectorProvider>(
          builder: (context, provider, _) {
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWeb ? 800 : screenWidth,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildImageSection(provider, context),
                      const SizedBox(height: 32),
                      _buildActionButtons(provider, context, isWeb),
                      const SizedBox(height: 32),
                      _buildAnalysisSection(provider, context),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildImageSection(
    AutismDetectorProvider provider,
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Upload  Image',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.blue.shade100, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child:
                    provider.hasImage
                        ? Image.memory(
                          provider.imageBytes!,
                          // fit: BoxFit.contain,
                        )
                        : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo_camera_back_rounded,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No image selected',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    AutismDetectorProvider provider,
    BuildContext context,
    bool isWeb,
  ) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      alignment: WrapAlignment.center,
      children: [
        _buildImageSourceButton(
          context,
          'Take Photo',
          Icons.camera_alt_rounded,
          isWeb ? Colors.blue : Theme.of(context).primaryColor,
          () {}, // Empty function as we'll handle it inside _buildImageSourceButton
        ),
        _buildImageSourceButton(
          context,
          'Choose from Gallery',
          Icons.photo_library_rounded,
          isWeb ? Colors.blue : Theme.of(context).primaryColor,
          () {}, // Empty function as we'll handle it inside _buildImageSourceButton
        ),
        // Remove the analyze button as it's no longer needed
      ],
    );
  }

  Widget _buildAnalysisButton(
    AutismDetectorProvider provider,
    BuildContext context,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.cyan.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => provider.analyzeImage(),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.analytics_rounded, color: Colors.white),
            SizedBox(width: 12),
            Text(
              'Analyze Image',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceButton(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return OutlinedButton.icon(
      icon: Icon(icon, color: color),
      label: Text(text, style: TextStyle(color: color)),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: BorderSide(color: color),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () async {
        final provider = Provider.of<AutismDetectorProvider>(
          context,
          listen: false,
        );
        await provider.pickImage(
          icon == Icons.camera_alt_rounded
              ? ImageSource.camera
              : ImageSource.gallery,
        );

        // Automatically analyze the image after selection
        if (provider.hasImage) {
          provider.analyzeImage();
        }
      },
    );
  }

  Widget _buildAnalysisSection(
    AutismDetectorProvider provider,
    BuildContext context,
  ) {
    if (provider.isLoading) {
      return Column(
        children: [
          const CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          const SizedBox(height: 24),
          Text(
            'Analyzing image...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    if (provider.hasResult) {
      final isError = provider.result!.containsKey('error');
      final isAutistic = provider.result!['result'] == "Autistic";

      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  isError
                      ? Icons.error_outline_rounded
                      : isAutistic
                      ? Icons.warning_amber_rounded
                      : Icons.check_circle_rounded,
                  size: 64,
                  color:
                      isError
                          ? Colors.amber
                          : isAutistic
                          ? Colors.orange
                          : Colors.green,
                ),
                const SizedBox(height: 20),
                Text(
                  isError ? 'Analysis Error' : provider.result!['result'],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color:
                        isError
                            ? Colors.amber
                            : isAutistic
                            ? Colors.orange
                            : Colors.green,
                  ),
                ),
                if (!isError) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Confidence Level: ${(provider.result!['prediction_value'] * 100).toStringAsFixed(1)}%',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ],
                if (isError) ...[
                  const SizedBox(height: 16),
                  Text(
                    provider.result!['error'],
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Start New Analysis'),
            onPressed: () => provider.resetState(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue.shade700,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
