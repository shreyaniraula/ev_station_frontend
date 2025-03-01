import 'dart:async';
import 'package:ev_charge/constants/styling_variables.dart';
import 'package:ev_charge/services/reservation/queue_service.dart';
import 'package:ev_charge/utils/custom_textfield.dart';
import 'package:flutter/material.dart';

class QueueScreen extends StatefulWidget {
  static const String routeName = '/queue-screen';
  const QueueScreen({super.key});

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController priorityController =
      TextEditingController(text: '5');

  final QueueService queueService = QueueService();
  final _formKey = GlobalKey<FormState>();

  String message = 'Not in queue';
  List<dynamic> queueList = [];
  bool isStationBusy = false;
  Timer? _timer;
  String myUserId = '66e39702f75f9e6b98f47f15';

  @override
  void initState() {
    super.initState();
    _timer =
        Timer.periodic(const Duration(seconds: 5), (_) => _getQueueStatus());
  }

  @override
  void dispose() {
    usernameController.dispose();
    priorityController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> joinQueue() async {
    final username = usernameController.text;
    final priority = priorityController.text;

    await queueService.joinQueue(
      context: context,
      username: username,
      priority: priority,
    );
    _getQueueStatus();
  }

  Future<void> _getQueueStatus() async {
    await queueService.getQueueStatus(
      context: context,
      updateState: (newQueueList, newIsStationBusy, newMessage) {
        setState(() {
          queueList = newQueueList;
          isStationBusy = newIsStationBusy;
          message = newMessage;
        });
      },
      myUserId: myUserId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Station Queue'),
        backgroundColor: Color.fromARGB(248, 203, 243, 175),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color.fromARGB(255, 240, 242, 246),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Username',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                CustomTextfield(
                  obscureText: false,
                  controller: usernameController,
                  icon: Icons.person,
                  labelText: 'Username',
                ),
                Text(
                  'Priority\n(lower number = higher priority)',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                CustomTextfield(
                  obscureText: false,
                  controller: priorityController,
                  icon: Icons.priority_high,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        joinQueue();
                      }
                    },
                    style: elevatedButtonStyle,
                    child: const Text(
                      'Join Queue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Display the current queue for debugging/visibility
                Expanded(
                  child: queueList.isEmpty
                      ? const Center(
                          child: Text('No queue items to display.'),
                        )
                      : ListView.builder(
                          itemCount: queueList.length,
                          itemBuilder: (context, index) {
                            final item = queueList[index];
                            return Card(
                              elevation: 2,
                              color: Color.fromARGB(248, 203, 243, 175),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 2,
                                  children: [
                                    Text('User: ${item['userId']}', style: TextStyle(fontSize: 18),),
                                    Text('Status: ${item['status']}', style: TextStyle(fontSize: 18),),
                                    Text('Priority: ${item['priority']}', style: TextStyle(fontSize: 18),),
                                    // const Divider(),
                                  ],
                                ),
                              ),
                              // title: Text('User: ${item['userId']}'),
                              // subtitle: Text('Status: ${item['status']}'),
                              // trailing: Text('Priority: ${item['priority']}'),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
