import { TestBed } from '@angular/core/testing';

import { DiffcomService } from './diffcom.service';

describe('DiffcomService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: DiffcomService = TestBed.get(DiffcomService);
    expect(service).toBeTruthy();
  });
});
