import { FieldValue } from '@google-cloud/firestore';

export interface Goal {
    readonly genre: [string];
    readonly new_things: string;
    readonly goal: [{ string: string }];
    readonly deadline: string;
    readonly achived_flag: boolean;
    readonly draft_flag: boolean;
    readonly like_count: number;
    readonly commented_count: number;
    readonly created_at: FieldValue;
    readonly updated_at: FieldValue;
}