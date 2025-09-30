import 'package:Kootumb/models/link_preview/link_preview.dart';
import 'package:Kootumb/models/post.dart';
import 'package:Kootumb/widgets/link_preview.dart';
import 'package:flutter/material.dart';

class OBPostBodyLinkPreview extends StatelessWidget {
  final Post? post;

  const OBPostBodyLinkPreview({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: StreamBuilder<Post>(
          stream: post?.updateSubject,
          initialData: post,
          builder: _buildLinkPreview),
    );
  }

  Widget _buildLinkPreview(BuildContext context, AsyncSnapshot<Post> snapshot) {
    if (post?.linkPreview != null) {
      return OBLinkPreview(
        linkPreview: post!.linkPreview,
      );
    }

    var linkToPreview = post!.getLinkToPreview()!;

    return OBLinkPreview(
        linkPreview: null,
        link: linkToPreview.link,
        onLinkPreviewRetrieved: _onLinkPreviewRetrieved);
  }

  void _onLinkPreviewRetrieved(LinkPreview? linkPreview) {
    post?.setLinkPreview(linkPreview);
  }
}
