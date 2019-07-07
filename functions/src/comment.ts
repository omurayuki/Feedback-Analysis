import { FieldValue } from '@google-cloud/firestore';

export interface Comment {
    readonly goal_document_id?: string;
    readonly comment: string;
    readonly like_count: number;
    readonly replied_count: number;
    readonly created_at: FieldValue;
    readonly updated_at: FieldValue;
}